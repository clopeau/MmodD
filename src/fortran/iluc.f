      subroutine iluc(n,a,ja,ia,lfil,droptol,param,alu,jlu,ju,
     +     iwk,w,jw,ierr)
c-----------------------------------------------------------------------
      implicit none
      integer n,iwk
      integer ja(*),ia(n+1),jlu(iwk),ju(n),jw(*),lfil,ierr,param
      doubleprecision a(*),alu(iwk),w(*)
      doubleprecision  droptol
c----------------------------------------------------------------------*
c                      *** ILUC preconditioner ***                     *
c Based on `Crout versions of ILU for general sparse matrices'         *
c by Na Li, Yousef Saad and Edmond Chow (tech. rep. UMSI 021, 2002)    *
c----------------------------------------------------------------------*
c Code written by Matthias Bollhoefer, August 23, 2002                 *
c----------------------------------------------------------------------*
c PARAMETERS                                                           
c-----------                                                           
c
c on entry:
c========== 
c n         integer. The row dimension of the matrix A. The matrix 
c
c a,ja,ia   matrix stored in Compressed Sparse Row format.              
c           ia: integer. array of size n+1. ia(j) points to the starting
c               position of row j, ia(n+1)=number of nonzeros +1, first
c               position behind row n
c           ja,a: integer/float array of size ia(n+1)-1. Column indices
c                 and associated numerical values
c           IMPORTANT: we assume that the column indices are stored in
c           increasing order. The algorithm may alter a and ja in order
c           change the order of the column indices and the numerical
c           values
c
c lfil      integer. The fill-in parameter. Each column of L and each 
c           row of U will have a maximum of lfil elements (excluding the
c           diagonal element). lfil must be .ge. 0.
c
c droptol   real*8. Sets the threshold for dropping small terms in the
c           factorization. See below for details on dropping strategy.
c
c  
c iwk       integer. The lengths of arrays alu and jlu. If the arrays
c           are not big enough to store the ILU factorizations, ilut
c           will stop with an error message. 
c
c param     integer. Options of iluc (to be read bitwise)
c           bit 0
c            0   simple dual threshold dropping strategy   
c            1   inverse based dropping strategy
c           bit 1
c            0   a zero pivot at step k is replaced by a small number 
c                (1e-4+droptol)*||U(k,:)||_inf
c            2   do not recover zero pivots
c           bit 2
c            0   simple Schur complement, very sparse but less accurate
c                version
c            4   Tismenetsky-like Schur complement, more dense but the 
c                error is squared
c           bit 3
c            0   the ILU is computed for the first time, no information
c                about the inverse triangular factors is provided
c            8   information about the inverse factors is provided from
c                a previous run. In this case w(n+1:3n) is assumed to
c                carry the information about the norm of L^{-1} but 
c                COLUMN-wise and U^{-1} but ROW-wise
c           bit 4
c            0   if bit 4 is NOT set, then the simple inverse-based 
c                dropping strategy is used
c           16   if bit 4 is set, then the inverse based dropping strategy
c                is improved by a more precise estimate of the inverse
c           bit 5
c            0   if bit 5 is NOT set, no diagonal compensation is done
c           32   if bit 5 is set, then diagonal compensation is used, 
c                i.e., we ensure that the ILU satisfies LU=A+E, where 
c                E*1=0 (1 denotes the vector with all entries equal to 1)
c
c On return:
c===========
c
c jlu,alu   integer/float array. 
c           recommended minimum size: n+1 + number of nonzeros of a.
c           Matrix stored in Modified Sparse Row (MSR) format containing
c           the L and U factors together. The diagonal (stored in
c           alu(1:n)) is inverted. The columns of L and rows of U are 
c           interlaced, starting from alu(n+2). jlu(1:n+1) points to the
c           start of each column (strict lower triangular part) of L
c
c ju        integer array of length n containing the pointers to
c           the beginning of each row of U in the matrix alu,jlu.
c
c ierr      integer. Error message with the following meaning.
c           ierr  = 0    --> successful return.
c           ierr .gt. 0  --> zero pivot encountered at step number ierr.
c           ierr  = -1   --> Error. input matrix may be wrong.
c                            (The elimination process has generated a
c                            row in L or U whose length is .gt.  n.)
c           ierr  = -2   --> The matrix L overflows the array al.
c           ierr  = -3   --> The matrix U overflows the array alu.
c           ierr  = -4   --> Illegal value for lfil.
c
c work arrays:
c=============
c jw        integer work array of length 9*n (if bit 2 is NOT set).
c           Then length is 11*n, if bit 2 is set.
c 
c           note that some variables share the same array. There is
c           no memory conflict because these variables access different
c           parts of the array at step k
c
c           jw(1:n)      index indicator array.
c                        in step k only jw(k+1:n) is used
c           jw(n+1:2n)   list of nonzero indices
c        
c           jw(2n+1:3n)  head of the linked list for the columns of A.
c                        on entry to step k only jw(2n+k:3n) is
c                        referenced, after that only jw(2n+k+1:3n) is
c                        needed
c           jw(3n+1:4n)  linked list for the leading columns of A
c                        (A is stored by rows)
c                        in step k only jw(3n+k+1:4n) is needed
c           jw(4n+1:5n)  pointer to the first entry at step k
c                        in step k only jw(3n+k+1:4n) is needed
c
c           jw(5n+1:6n)  linked list to the nonzero elements in row k of
c                        L (although L is stored by columns). jw(5n+k) 
c                        contains the reference of the first nonzero
c                        entry, jw(5n+jw(5n+k)) the second one and so on
c                        until a zero is reached which indicates the end
c           jw(1:n)      pointer to first element of L(k:n,j) for 1<=j<k
c                        on entry to step k, only jw(1:k-1) is 
c                        referenced, at the end (in `iluclist'), jw(k)
c                        is also set
c
c           jw(6n+1:7n)  linked list to the nonzero elements in column k
c                        of U (although U is stored by rows). jw(3n+k) 
c                        contains the reference of the first nonzero
c                        entry, jw(7n+jw(7n+k)) the second one and so on
c                        until a zero is reached which indicates the end
c           jw(2n+1:3n)  pointer to first element of U(j,k:n) for 1<=j<k
c                        on entry to step k, only jw(2n+1:2n+k-1) is 
c                        referenced, at the end (in `iluclist'), 
c                        jw(2n+k) is also set
c
c           jw(3n+1:4n)  additional auxiliary pointer to the
c                        free space behind the regular part of L.
c                        on entry to step k, only jw(3n+1:3n+k-1) is
c                        referenced, later on when sparsifying column k
c                        of L, jw(3n+k) is set
c           jw(4n+1:5n)  additional auxiliary pointer to the
c                        free space behind the regular part of U.
c                        on entry to step k, only jw(4n+1:4n+k-1) is
c                        referenced, later on when sparsifying row k
c                        of U, jw(4n+k) is set
c
c           jw(7n+1:8n)  counter for the number of essential nonzeros in
c                        each row of L^{-1}, used to estimate the
c                        infinity norm based on the 1-norm estimate that
c                        is computed on entry to step k, only
c                        jw(7n+k:8n) is referenced, later on after
c                        sparsifying jw(7n+k) is no longer needed
c           
c           jw(8n+1:9n)  counter for the number of essential nonzeros in
c                        each column of U^{-1}, used to estimate the
c                        infinity norm based on the 1-norm estimate that
c                        is computed on entry to step k, only
c                        jw(8n+k:9n) is referenced, later on after
c                        sparsifying jw(8n+k) is no longer needed
c           
c           if bit 2 of param is set:
c           jw(9n+1:10n) linked list to the nonzero elements in row k of
c                        L, part with epsilon size values (although L is
c                        stored by columns). jw(9n+k) contains the
c                        reference of the first nonzero entry,
c                        jw(9n+jw(9n+k)) the second one and so on 
c                        until a zero is reached which indicates the end
c           jw(7n+1:8n)  pointer to first element of L(k:n,j) for j<k,
c                        epsilon size part.
c                        on entry to step k, only jw(7n+1:7n+k-1) is 
c                        referenced, at the end in `iluclist', jw(7n+k)
c                        is also set
c
c           jw(10n+1:11n)linked list to the nonzero elements in column k
c                        of U, part with epsilon size values (although U
c                        is stored by rows). jw(10n+k) contains the
c                        reference of the first nonzero entry,
c                        jw(10n+jw(10n+k)) the second one and so on
c                        until a zero is reached which indicates the end
c           jw(8n+1:9n)  pointer to first element of U(j,k:n) for j<k,
c                        epsilon size part
c                        on entry to step k, only jw(8n+1:8n+k-1) is 
c                        referenced, at the end in `iluclist', jw(8n+k)
c                        is also set
c
c
c w         real work array of length n if bit 0 is NOT set, 3*n if bit
c           0 is set (inverse based dropping), 5*n if bit 0 and 4 are
c           both set
c
c           w(1:n)       used as buffer for the numerical values
c
c           if bit 0 is set to 1 and bit 3 is NOT set:
c           w(n+1:2n)    condition estimator for L
c           w(2n+1:3n)   condition estimator for U
c
c           if bit 0 is set to 1 and bit 3 is set to 8:
c           w(n+1:2n)    input information for norm estimation of 
c                        ||L^{-1}(:,k)||_inf from a previous run
c           w(2n+1:3n)   input information for norm estimation of 
c                        ||U^{-1}(k,:)||_inf from a previous run
c
c           if bit 0 is set to 1, bit 4 is set to 16 and bit 3 is NOT set:
c           w(3n+1:4n)   improved condition estimator for L
c           w(4n+1:5n)   improved condition estimator for U
c  
c----------------------------------------------------------------------*
c     locals
      integer i,j,k,l,m,n2,n3,n4,n5,n6,n7,n8,n9,n10
      integer droptype,pivottype,sctype,len,zeropivots,invinfo,improved,
     +        milu 
      doubleprecision Lmax,Umax,ax,ay,axp,axm,mup,mum,absaluk,
     +                 droptolL,droptolU,sdroptol
      doubleprecision   ialuk,aluk,y,x,signum,xp,xm
     
      intrinsic min0
      doubleprecision dabs,dsqrt

c i,j,k,l,m        counters
c
c n2,...,n10       abbreviations for 2*n,...,10*n
c
c droptype         0 standard dropping,       1 inverse based dropping
c pivottype        0 shift zero pivots,       1 don't shift zero pivots
c sctype           0 simple Schur complement, 1 Tismenetsky-like
c milu             0 no diagonal comp.        1 diagonal comp. used
c
c len              number of nonzeros in column/row k of L/U
c
c Lmax,Umax        maximum element of |L(k:n,k)*U(k,k)| and |U(k,k:n)|
c 
c x,xp,xm,mup,mum  used for inverse-based dropping
c
c absaluk             |U(k,k)| 
      print *, lfil,droptol

      if (lfil.lt.0) goto 994

c     square root of the drop tolerance
      sdroptol=dsqrt(droptol)

c     count how often we encountered a zero pivot
      zeropivots=0

c     abbreviations
      n2 =n  +n
      n3 =n2 +n
      n4 =n3 +n
      n5 =n4 +n
      n6 =n5 +n
      n7 =n6 +n
      n8 =n7 +n
      n9 =n8 +n
      n10=n9 +n

c     bit 0
c     which kind of dropping do we use
c     0 standard, 1 inverse based
c      print *,param
      i=param
      droptype=mod(i,2)
      print *,'dropping  0 standard, 1 inverse : ',droptype
c
c     bit 1
c     should we shift zero pivots
c     0 yes, 1 no
      i=i/2
      pivottype=mod(i,2)
      print *,'zero pivots 0 oui, 1 non :',pivottype
c
c     bit 2
c     which kind of Schur complement do we use
c     0 simple, 1 Tismenetsky-like
      i=i/2
      sctype=mod(i,2)
      print *,'shur comp 0 simple 2 Timen : ',sctype
c     bit 3
c     is any information about the inverse factors provided?
c     0 no, 1 yes
      i=i/2
      invinfo=mod(i,2)
      print *,'inversefactor : ',invinfo

c     bit 4
c     is an improved estimate desired?
c     0 no, 1 yes
      i=i/2
      improved=mod(i,2)
      print *,' improved: ',improved
c     bit 5
c     is a diagonal compensation desired
c     0 no, 1 yes
      i=i/2
      milu=mod(i,2)
      print *,' milu : ',milu


c     ensure that the entries of A in any row are sorted in 
c     increasing order
      do 10 i=1,n
         j=ia(i)
         k=ia(i+1)-j
c        row i is empty
         if (k.le.0) goto 991

         call qsort2(a(j),ja(j),jw(n+1),k)

c        column indices are out of range
         if (ja(j).lt.1 .or. ja(j+k-1).gt.n) goto 991

c        also clear some space
c
c        clear space for the nonzero indicator array
         jw(i)=0
c
c        clear Llist 
         jw(n5+i)=0
c
c        clear Ulist
         jw(n6+i)=0
c
c        clear workspace for the numerical values
         w(i)=0.0d0
 10   continue

c     clear estimates for the norm of the inverse
      if (droptype.gt.0 .and. invinfo.eq.0) then
         do 20 i=1,n
c           clear arrays to hold the estimates for the inverses
            w(n+i)=0.0d0
            w(n2+i)=0.0d0
c           init counter arrays
            jw(n7+i)=0
            jw(n8+i)=0
 20      continue
         if (improved.gt.0) then
            do 25 i=1,n
               w(n3+i)=0.0d0
               w(n4+i)=0.0d0
 25         continue
         end if
      end if
c
c     clear workspace for Tismenetsky-like update
      if (sctype.gt.0) then
         do 30 i=1,n
c           clear Llist (epsilon size part)
            jw(n9+i)=0
c     
c           clear Ulist (epsilon size part)
            jw(n10+i)=0
 30      continue
      end if

c     set up arrays for A^T (A is stored by rows)
c
c     jw(2n+1:3n)  head of the linked list for the columns of A
c     jw(3n+1:4n)  linked list for the leading columns of A up to step k
c     jw(4n+1:5n)  pointer to the first entry at step k
      do 40 k=1,n
c        clear head of the linked list (empty) 
         jw(n2+k)=0
 40   continue
      do 50 i=1,n
c        pointer to the first nonzero element in row i
         j=ia(i)
c        column index k of  A(i,k)
         k=ja(j)
c        we only have to store i, if k<i (strict lower triangular part)
c        in addition we have to make sure that we are still inside row i
         if (k.lt.i .and. j.lt.ia(i+1)) then
c           pointer to the current first nonzero entry in row i
            jw(n4+i)=j
c           add new entry to the head of the list
            jw(n3+i)=jw(n2+k)
            jw(n2+k)=i
         end if
 50   continue



c     extract diagonal part of A and store it in alu(1:n)
      l=ia(1)
      do 80 i=1,n
         alu(i)=0
         k=l
         l=ia(i+1)
c        while k<l and ja(k)<i
 90         if (k.ge.l .or. ja(k).ge.i) goto 100
            k=k+1
         goto 90
c        end while
 100     if (k.lt.l .and. ja(k).eq.i) alu(i)=a(k)
 80   continue


c     initial values for jlu, jlu(1:n+1) are used as pointers to point
c     to the L part, so the indices start at n+2
      jlu(1)=n+2
      if (iwk.lt.n+1) goto 992

c     main loop
      do 110 k=1,n

c        -----   dealing with the lower triangular part   -----
c
c        extract strict lower triangular part of A, column k
         len=0
c        if A(k+1:n,k) is nonempty, get the enrty point to the linked
c        list of column k
         i=jw(n2+k)
c        while i>0         
 120        if (i.le.0) goto 130

            len=len+1
c           flag component i as nonzero
            jw(i)=len
c           add i to the list of nonzeros
            jw(n+len)=i
c           pointer to A(i,k)
            j=jw(n4+i)
c           extract numerical value
            w(i)=a(j)
c           store next row from the linked list
            m=jw(n3+i)

c           update column information
            jw(n4+i)=jw(n4+i)+1
c           pointer to the next nonzero element in row i
            j=jw(n4+i)
c           column index l of  A(i,l)
            l=ja(j)
c           we only have to store i, if l<i, strict lower triangular
c           part, in addition we have to make sure that we are still
c           inside row i
            if (l.lt.i .and. j.lt.ia(i+1)) then 
c              add new entry to the head of the list
               jw(n3+i)=jw(n2+l)
               jw(n2+l)=i
            end if

c           recover next row entry
            i=m
         goto 120
c        end while

 
c        update column k of the Schur complement by subtracting any
c        previous column i=1,...,k-1 depending on the nonzero entries
c        of U(1:k-1,k)
c
 130     if (sctype.gt.0) then
c           additional Tismenetsky updates using regular previous 
c           columns of L but epsilon size elements of U
c           
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           jlu(2)    pointers to the first space behind any row of U
c                     (behind the epsilon size entries)
c           jw(n3+1)  pointers to the first space behind any column of L
c                     (behind the regular entries)
c           jw(n10+1) Ulist for the epsilon size part of U
c           jw(n8+1)  Ufirst for the epsilon size part of U
c           jw        Lfirst for the regular part of L
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
            call ilucupdate(n,k,alu,jlu,jlu(2),jw(n3+1),jw(n10+1),
     +                      jw(n8+1),jw,jw,len,w)

c           additional Tismenetsky updates using epsilon size previous
c           columns of L but regular elements of U
c           
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           jw(n4+1)  pointers to the first space behind any row of U
c                     (behind the regular entries)
c           ju        pointers to the first space behind any column of L
c                     (behind the epsilon size entries)
c           jw(n6+1)  Ulist for the regular part of U
c           jw(n2+1)  Ufirst for the regular part of U
c           jw(n7+1)  Lfirst for the epsilon size part of L
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
            call ilucupdate(n,k,alu,jlu,jw(n4+1),ju,jw(n6+1),jw(n2+1),
     +                      jw(n7+1),jw,len,w)
         end if
         
c        regular update 
c        n         size of the problem
c        k         current step of the update
c        alu       numerical values
c        jlu       associated indices
c        jw(n4+1)  pointers to the first space behind any row of U
c                  (behind the regular entries)
c        jw(n3+1)  pointers to the first space behind any column of L
c                  (behind the regular entries)
c        jw(n6+1)  Ulist for the regular part of U
c        jw(n2+1)  Ufirst for the regular part of U
c        jw        Lfirst for the regular part of L
c        jw        indices of nonzero entries and associated list
c        len       length of this list
c        w         numerical values
         call ilucupdate(n,k,alu,jlu,jw(n4+1),jw(n3+1),jw(n6+1),
     +                   jw(n2+1),jw,jw,len,w)

c        position where the next row of U starts
         ju(k)=jlu(k)+len
         if (ju(k)-1.gt.iwk) goto 992
c        Compute maximal entry in absolute value of column k of L
         Lmax=dabs(alu(k))
         do 135 j=1,len
            l=jw(n+j)
            if (dabs(w(l)).gt.Lmax) Lmax=dabs(w(l))
 135     continue
c        shift zero diagonal entry if desired
         if (alu(k).eq.0.0d0) then
            zeropivots=zeropivots+1
            if (pivottype.gt.0) then
c              ERROR 
               goto 990
            else
               alu(k)=(1.0d-4+droptol)*Lmax
            end if 
         end if
         aluk=alu(k)
c        invert diagonal entry
         ialuk=1.0d0/aluk
c        for several estimates we still need |D(k,k)|
         absaluk=dabs(aluk)
c        copy buffer to jlu/alu
         j=1
         do 140 i=jlu(k),ju(k)-1
c           extract row index l from the list of nonzeros
            l=jw(n+j)
            jlu(i)=l
c           extract numerical value
            alu(i)=w(l)
c           clear auxiliary space
            w(l)=0.0d0
c           clear flag
            jw(l)=0
            j=j+1
 140     continue
         
c        estimate norm of the rows of L^{-1}
         if (droptype.gt.0 .and. invinfo.eq.0) then
            signum=1.0d0
c#if !defined _DOUBLE_REAL_ && !defined _SINGLE_REAL_
c$$$            mup=0.0d0
c$$$            j=jlu(k)
c$$$            do i=jlu(k),ju(k)-1
c$$$               l=jlu(i)
c$$$               if (dabs(w(n+l))+dabs(alu(i)) .gt. mup) then 
c$$$                  mup=dabs(w(n+l))+dabs(alu(i))
c$$$                  j=i
c$$$               endif
c$$$            enddo
c$$$c           choose the sign such that component l is maximized
c$$$            if (jlu(k).lt.ju(k)) then
c$$$               l=jlu(j)
c$$$               if (      w(n+l).ne.0.0d0 
c$$$     +              .and. alu(j).ne.0.0d0) then
c$$$                  signum=(w(n+l)/dabs(w(n+l)))
c$$$     +                 *((alu(j))/dabs(alu(j)))
c$$$               endif
c$$$            endif
c#else
c#endif
c           try +/-1 as k-th component of the right hand side
            xp=( SIGNUM-w(n+k))*ialuk
            xm=(-SIGNUM-w(n+k))*ialuk
c           for both cases estimate the 1-norm of L^{-1} by evaluating
c           L(k+1:n,1:k)*L(1:k,1:k)^{-1}*rhs(1:k)
            mup=0.0d0
            mum=0.0d0
            do 150 i=jlu(k),ju(k)-1
c              row index l
               l=jlu(i)
               mup=mup+dabs(w(n+l)+xp*alu(i))
               mum=mum+dabs(w(n+l)+xm*alu(i))
 150        continue
            if (mup.ge.mum) then
               x=xp
            else
               x=xm
            end if

c           number of peaks in column k
            m=jw(n7+k)
c           will the diagonal entry become a peak of row k
c           this is the case if the average of peaks is at most 1
            if (dabs(w(n+k)).le.dble(m)) m=m+1
c           store new number of peaks
            jw(n7+k)=m
            do 160 i=jlu(k),ju(k)-1
               l=jlu(i)
               y=x*alu(i)
c              will we have a serious contribution to the rank-1 update
c              of L^{-1} in row l?
c              the new average of peaks |y|/m caused by the rank-1
c              update is at least as much as the current average of
c              peaks |w(n+l)|/jw(n7+l) in row l
               if (dabs(y)*dble(jw(n7+l)).ge.dabs(w(n+l))*dble(m))
     +             jw(n7+l)=m
               w(n+l)=w(n+l)+y
 160        continue
            axp=dabs( SIGNUM-w(n+k))
            axm=dabs(-SIGNUM-w(n+k))
            w(n+k)=axm
            if (axp.gt.axm) w(n+k)=axp
c
c           improved estimate using a different right hand side
            if (improved.gt.0) then
c              try +/-1 as k-th component of the right hand side
               xp=( SIGNUM-w(n3+k))*ialuk
               xm=(-SIGNUM-w(n3+k))*ialuk
c              for both cases count the number of serious changes by evaluating
c              L(k+1:n,1:k)*L(1:k,1:k)^{-1}*rhs(1:k)
               j=0
               m=0
               do 155 i=jlu(k),ju(k)-1
c                 row index l
                  l=jlu(i)
                  ax=dabs(w(n3+l))
                  ay=dabs(w(n3+l)+xp*alu(i))
c                 entry seriously increases                  
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  j=j+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  j=j-1
                  ay=dabs(w(n3+l)+xm*alu(i))
c                 entry seriously increases              
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  m=m+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  m=m-1
 155           continue
               if (j.ge.m) then
                  x=xp
               else
                  x=xm
               end if
               do 165 i=jlu(k),ju(k)-1
c                 row index l
                  l=jlu(i)
                  w(n3+l)=w(n3+l)+x*alu(i)
 165           continue
               axp=dabs( SIGNUM-w(n3+k))
               axm=dabs(-SIGNUM-w(n3+k))
               if (axm.gt.(w(n+k))) w(n+k)=axm
               if (axp.gt.(w(n+k))) w(n+k)=axp
            end if
c           estimate the infinity norm from the estimate of the 1-norm
c           by dividing the 1-norm by the estimated number of essential
c           nonzeros in row k
c           on the average we expect that half of the off-diagonal
c           entries may cancel as a result of using only one test vector
            if (jw(n7+k).gt.2) w(n+k)=2*w(n+k)/dble(jw(n7+k))
            if ((w(n+k)).lt.1.0d0) w(n+k)=1.0d0
         end if
c        end estimate norm of the inverse 


c        -----   dealing with the upper triangular part   -----
c
c        extract strict upper triangular part of A, row k
         j=ia(k)
c        while j<ia(k+1) and ja(j)<=k
 220        if (j.ge.ia(k+1) .or. ja(j).gt.k) goto 210
            j=j+1
         goto 220
c        end while
 210     len=0
         do 230 l=j,ia(k+1)-1
c           column index i
            i=ja(l)
            len=len+1
c           flag component i as nonzero
            jw(i)=len
c           add i to the list of nonzeros
            jw(n+len)=i
c           extract numerical value
            w(i)=a(l)
 230     continue

c        update row k of the Schur complement by subtracting any
c        previous row i=1,...,k-1 depending on the nonzero entries
c        of L(k,1:k-1)
c        
         if (sctype.gt.0) then
c           additional Tismenetsky updates using regular previous rows
c           of U but epsilon size elements of L
c           
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           ju        pointers to the first space behind any column of L
c                     (behind the epsilon size entries)
c           jw(n4+1)  pointers to the first space behind any row of U
c                     (behind the regular entries)
c           jw(n9+1)  Llist for the epsilon size part of L
c           jw(n7+1)  Lfirst for the epsilon size part of L
c           jw(n2+1)  Ufirst for the regular part of U
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
            call ilucupdate(n,k,alu,jlu,ju,jw(n4+1),jw(n9+1),
     +                      jw(n7+1),jw(n2+1),jw,len,w)

c           additional Tismenetsky updates using epsilon size previous
c           rows of U but regular elements of L
c           
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           jw(n3+1)  pointers to the first space behind any column of L
c                     (behind the regular entries)
c           jlu(2)    pointers to the first space behind any row of U
c                     (behind the epsilon size entries)
c           jw(n5+1)  Llist for the regular part of L
c           jw        Lfirst for the regular part of L
c           jw(n8+1 ) Ufirst for the epsilon size part of U
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
            call ilucupdate(n,k,alu,jlu,jw(n3+1),jlu(2),jw(n5+1),
     +                      jw,jw(n8+1),jw,len,w)
         end if
         
c        regular update 
c        n         size of the problem
c        k         current step of the update
c        alu       numerical values
c        jlu       associated indices
c        jw(n3+1)  pointers to the first space behind any column of L
c                  (behind the regular entries)
c        jw(n4+1)  pointers to the first space behind any row of U
c                  (behind the regular size entries)
c        jw(n5+1)  Llist for the regular part of L
c        jw        Lfirst for the regular part of L
c        jw(n2+1)  Ufirst for the regular part of U
c        jw        indices of nonzero entries and associated list
c        len       length of this list
c        w         numerical values
         call ilucupdate(n,k,alu,jlu,jw(n3+1),jw(n4+1),jw(n5+1),
     +                   jw,jw(n2+1),jw,len,w)

c        position where the next column of L starts
         jlu(k+1)=ju(k)+len
         if (jlu(k+1)-1.gt.iwk) goto 993
         j=1
         Umax=absaluk
         do 240 i=ju(k),jlu(k+1)-1
c           extract column index l from the list of nonzeros
            l=jw(n+j)
            if (dabs(w(l)).gt.Umax) Umax=dabs(w(l))
            jlu(i)=l
c           extract numerical value
            alu(i)=w(l)
c           DON'T clear auxiliary space w(l) at this point, it is still
c           needed
c           clear flag
            jw(l)=0
            j=j+1
 240     continue

c        estimate norm of the columns of U^{-1}
         if (droptype.gt.0 .and. invinfo.eq.0) then
            signum=1.0d0
c#if !defined _DOUBLE_REAL_ && !defined _SINGLE_REAL_
c$$$            mup=0.0d0
c$$$            j=ju(k)
c$$$            do i=ju(k),jlu(k+1)-1
c$$$               l=jlu(i)
c$$$               if (dabs(w(n2+l))+dabs(alu(i)) .gt. mup) then 
c$$$                  mup=dabs(w(n2+l))+dabs(alu(i))
c$$$                  j=i
c$$$               endif
c$$$            enddo
c$$$c           choose the sign such that component l is maximized
c$$$            if (ju(k).lt.jlu(k+1)) then
c$$$               l=jlu(j)
c$$$               if (     w(n2+l).ne.0.0d0 
c$$$     +              .and. alu(j).ne.0.0d0) then
c$$$                  signum=(w(n2+l)/dabs(w(n2+l)))
c$$$     +                 *((alu(j))/dabs(alu(j)))
c$$$               endif
c$$$            endif
c#else
c#endif
c           try +/-1 as k-th component of the right hand side
            xp=( SIGNUM-w(n2+k))*ialuk
            xm=(-SIGNUM-w(n2+k))*ialuk
c           for both cases estimate the 1-norm of U^{-T} by evaluating
c           U(1:k,k+1:n)^T*U(1:k,1:k)^{-T}*rhs(1:k)
            mup=0.0d0
            mum=0.0d0
            do 250 i=ju(k),jlu(k+1)-1
c              row index l
               l=jlu(i)
               mup=mup+dabs(w(n2+l)+xp*alu(i))
               mum=mum+dabs(w(n2+l)+xm*alu(i))
 250        continue
            if (mup.ge.mum) then
               x=xp
            else
               x=xm
            end if

c           number of peaks in column k
            m=jw(n8+k)
c           will the diagonal entry become a peak of column k
c           this is the case if the average of peaks is at most 1
            if (dabs(w(n2+k)).le.dble(m)) m=m+1
c           store new number of peaks
            jw(n8+k)=m
            do 260 i=ju(k),jlu(k+1)-1
               l=jlu(i)
               y=x*alu(i)
c              will we have a serious contribution to the rank-1 update
c              of U^{-1} in column l?
c              the new average of peaks |y|/m caused by the rank-1
c              update is at least as much as the current average of
c              peaks |w(n2+l)|/jw(n8+l) in column l
               if (dabs(y)*dble(jw(n8+l)).ge.dabs(w(n2+l))*dble(m))
     +             jw(n8+l)=m
               w(n2+l)=w(n2+l)+y
 260        continue
            axp=dabs( SIGNUM-w(n2+k))
            axm=dabs(-SIGNUM-w(n2+k))
            w(n2+k)=axm
            if (axp.gt.axm) w(n2+k)=axp
c
c           improved estimate using a different right hand side
            if (improved.gt.0) then
c              try +/-1 as k-th component of the right hand side
               xp=( SIGNUM-w(n4+k))*ialuk
               xm=(-SIGNUM-w(n4+k))*ialuk
c              for both cases count the number of serious changes by evaluating
c              U(1:k,k+1:n)^T*U(1:k,1:k)^{-T}*rhs(1:k)
               j=0
               m=0
               do 255 i=ju(k),jlu(k+1)-1
c                 row index l
                  l=jlu(i)
                  ax=dabs(w(n4+l))
                  ay=dabs(w(n4+l)+xp*alu(i))
c                 entry seriously increases                  
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  j=j+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  j=j-1
                  ay=dabs(w(n4+l)+xm*alu(i))
c                 entry seriously increases              
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  m=m+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  m=m-1
 255           continue
               if (j.ge.m) then
                  x=xp
               else
                  x=xm
               end if
               do 265 i=ju(k),jlu(k+1)-1
                  l=jlu(i)
                  w(n4+l)=w(n4+l)+x*alu(i)
 265           continue
               axp=dabs( SIGNUM-w(n4+k))
               axm=dabs(-SIGNUM-w(n4+k))
               if (axm.gt.(w(n2+k))) w(n2+k)=axm
               if (axp.gt.(w(n2+k))) w(n2+k)=axp
            end if
c           estimate the infinity norm from the estimate of the 1-norm
c           by dividing the 1-norm by the estimated number of essential
c           nonzeros in column k
c           on the average we expect that half of the off-diagonal
c           entries may cancel as a result of using only one test vector
            if (jw(n8+k).gt.2) w(n2+k)=2*w(n2+k)/dble(jw(n8+k))
            if ((w(n2+k)).lt.1.0d0) w(n2+k)=1.0d0
         end if
c        end estimate norm of the inverse 



c        -----   sparsify L and U   -----
c
c        drop tolerances
c
c        classical dropping
c        drop entries that are less than a tolerance droptol multiplied
c        by the absolute value of the diagonal entry
         droptolL=droptol*absaluk
         droptolU=droptolL
c        do we use inverse-based dropping?
         if (droptype.gt.0) then
            if (invinfo.eq.0) then
               droptolL=droptolL/(w(n+k))
               droptolU=droptolU/(w(n2+k))
c
c           inverse-based dropping based on previously computed
c           estimates for the column norms of L^{-1} and row norms of
c           U^{-1}
            else
c              simple Schur complement update
c              (non-Tismenetsky Schur complement update)
               if (sctype.eq.0) then
                  droptolL=droptolL/(w(n2+k))
                  droptolU=droptolU/(w(n+k))
               end if 
            end if 
         end if 

c        lower triangular part
c        separate nonzero entries of column k of L between those which
c        are greater than droptolL and those which are equal to or less
c        than droptolL (in absolute values)
         i=jlu(k)
         j=ju(k)
c        while i<j
 270        if (i.ge.j) goto 280
            x=1.0d0
c           row index
            l=jlu(i)
c           include previous norm estimate of L^{-1}(:,l) from the 
c           first pass
            if (invinfo.gt.0) x=w(n+l)
c           move small size entries to the end
c
c           keep in mind that w(l) still contains the values of the U
c           part!
c
c           ensure that we ONLY drop entries |L(l,k)| that are:
c           1. less than the associated diagonal entry D(l,l), since
c              D(l,l) is updated by L(l,k)*D(k,k)*U(k,l)
c              (D(k,k) already refers to the inverse diagonal entry,
c               while D(l,l) is not yet inverted)
c           2. small compared with the regular or inverse-based
c              drop tolerance
            if (dabs(alu(i)*ialuk*w(l)).le.droptol*dabs(alu(l))
     +          .and. dabs(x*alu(i)).le.droptolL) then
               j=j-1
               
c              swap entries
               x=alu(i)
               alu(i)=alu(j)
               alu(j)=x
               
               jlu(i)=jlu(j)
               jlu(j)=l
            else
               i=i+1
            end if
         goto 270
c        end while
c
c        now starting from position j we will have all the dirt
c
c        NOW we can clear the U part
 280     do 285 i=ju(k),jlu(k+1)-1
            l=jlu(i)
c           clear auxiliary space
            w(l)=0.0d0
 285     continue

c        truncate column k such that we will have at most lfil entries
c        first truncate the regular part if necessary
         i=jlu(k)
c        maximum length
         len=min0(j-i,lfil)
c        select the `len' largest entries in modulus
         call qsplit(alu(i),jlu(i),j-i,len)

c        apply diagonal compensation if desired
         if (milu.gt.0) then
            do 290 l=i+len,ju(k)-1
               m=jlu(l)
               alu(m)=alu(m)+alu(l)
 290        continue
         end if

         if (sctype.gt.0) then
c           Tismenetsky case
c           if there is some space leftover, truncate the epsilon part
            if (j-i.lt.lfil) then
c              maximum length
               len=min0(ju(k)-j,lfil-j+i)
               call qsplit(alu(j),jlu(j),ju(k)-j,len)
               len=len+j-i
            else
               j=i+len
            end if
         else
c           simple case
            j=i+len
         end if
c        keep a pointer to the first space behind the regular part of L
         jw(n3+k)=j
c        sort regular part and epsilon size part separately
         call qsort2(alu(i),jlu(i),jw(n+1),j-i)
         call qsort2(alu(j),jlu(j),jw(n+1),len-j+i)
c        shift size for the U part
         m=ju(k)-jlu(k)-len


c        upper triangular part
c
c        restore the remaining lower triangular part to w
         do 295 i=jlu(k),jw(n3+k)-1
            l=jlu(i)
            w(l)=alu(i)
 295     continue
c
c        separate nonzero entries of row k of U between those
c        which greater than droptolU and those which equal to or less
c        than droptolU (all in absolute values)
         i=ju(k)
         j=jlu(k+1)
c        while i<j
 370        if (i.ge.j) goto 380
            x=1.0d0
c           column index
            l=jlu(i)
c           include previous norm estimate of U^{-1}(l,:) from the 
c           first pass
            if (invinfo.gt.0) x=w(n2+l)
c           move small size entries to the end
c
c           recall that w(l) now contains the values of the L part!
c
c           ensure that we ONLY drop entries |U(k,l)| that are:
c           1. less than the associated diagonal entry D(l,l), since
c              D(l,l) is updated by L(l,k)*D(k,k)*U(k,l)
c              (D(k,k) already refers to the inverse diagonal entry,
c               while D(l,l) is not yet inverted)
c           2. small compared with the regular or inverse-based
c              drop tolerance
            if (dabs(w(l)*ialuk*alu(i)).le.droptol*dabs(alu(l))
     +          .and. dabs(x*alu(i)).le.droptolU) then
               j=j-1
               
c              swap entries
               x=alu(i)
               alu(i)=alu(j)
               alu(j)=x
               
               jlu(i)=jlu(j)
               jlu(j)=l
            else
               i=i+1
            end if
         goto 370
c        end while
c
c        now starting from position j we will have all the dirt
c
c        NOW finally clear w
 380     do 395 i=jlu(k),jw(n3+k)-1
            l=jlu(i)
            w(l)=0.0d0
 395     continue

c        find out whether we have at most lfil entries
c        first truncate the regular part if necessary
         i=ju(k)
c        maximum length
         len=min0(j-i,lfil)
c        select the `len' largest entries in modulus
         call qsplit(alu(i),jlu(i),j-i,len)

c        apply diagonal compensation if desired
         if (milu.gt.0) then
            do 392 l=i+len,jlu(k+1)-1
               alu(k)=alu(k)+alu(l)
 392        continue
         end if
c        invert diagonal entry
         alu(k)=1.0d0/alu(k)

c        Tismenetsky case
         if (sctype.gt.0) then
c           refined diagonal compensation
            if (milu.gt.0) then
               xp=0.0d0
               xm=0.0d0
               do 393 l=i,i+len-1
                  xp=xp+alu(l)
 393           continue
               do 394 l=i+len,jlu(k+1)-1
                  xm=xm+alu(l)
 394           continue
               xp=xp*alu(k)
               xm=xm*alu(k)
               do 396 l=jlu(k),jw(n3+k)-1
                  m=jlu(l)
                  alu(m)=alu(m)+alu(l)*xm
 396           continue
               do 397 l=jw(n3+k),ju(k)-1
                  m=jlu(l)
                  alu(m)=alu(m)+alu(l)*xp
 397           continue
            end if

c           if there is some space leftover truncate the epsilon part
            if (j-i.lt.lfil) then
c              maximum length
               len=min0(jlu(k+1)-j,lfil-j+i)
               call qsplit(alu(j),jlu(j),jlu(k+1)-j,len)
               len=len+j-i
            else
               j=i+len
            end if
         else
c           simple case
            j=i+len
         end if
c        shift U part by m spaces
         if (m.gt.0) then
            do 390 i=ju(k),ju(k)+len-1
               alu(i-m)=alu(i)
               jlu(i-m)=jlu(i)
 390        continue
         end if
c        shift starting position of the U part by m
         ju(k)=ju(k)-m
c        adapt new starting position of next column of L
         jlu(k+1)=ju(k)+len
c        keep a pointer to the first space behind the regular part of L,
c        shifted by m
         j=j-m
         jw(n4+k)=j
c        sort regular part and epsilon size part separately
         i=ju(k)
         call qsort2(alu(i),jlu(i),jw(n+1),j-ju(k))
         call qsort2(alu(j),jlu(j),jw(n+1),jlu(k+1)-j)


c        -----   update diagonal entries   -----
c
c        Tismenetsky update
         if (sctype.gt.0) then
c           update - regular part and epsilon size part
            i=jlu(k)
            j=jw(n4+k)
c           while i<jw(n3+k) and j<jlu(k+1)
 420           if (i.ge.jw(n3+k) .or. j.ge.jlu(k+1)) goto 430
               l=jlu(i)
               m=jlu(j)
               if (l.eq.m) then
                  alu(l)=alu(l)-alu(i)*alu(k)*alu(j)
                  i=i+1
                  j=j+1
               else
                  if (l.lt.m) then
                     i=i+1
                  else
                     j=j+1
                  end if
               end if
            goto 420
c           end while
c
c           update - epsilon size part and regular part
 430        i=jw(n3+k)
            j=ju(k)
c           while i<ju(k) and j<jw(n4+k)
 440           if (i.ge.ju(k) .or. j.ge.jw(n4+k)) goto 450
               l=jlu(i)
               m=jlu(j)
               if (l.eq.m) then
                  alu(l)=alu(l)-alu(i)*alu(k)*alu(j)
                  i=i+1
                  j=j+1
               else
                  if (l.lt.m) then
                     i=i+1
                  else
                     j=j+1
                  end if
               end if
            goto 440
c           end while
 450     end if   
c        regular update
         i=jlu(k)
         j=ju(k)
c        while i<jw(n3+k) and j<jw(n4+k)
 400        if (i.ge.jw(n3+k) .or. j.ge.jw(n4+k)) goto 410
            l=jlu(i)
            m=jlu(j)
            if (l.eq.m) then
               alu(l)=alu(l)-alu(i)*alu(k)*alu(j)
               i=i+1
               j=j+1
            else
               if (l.lt.m) then
                  i=i+1
               else
                  j=j+1
               end if
            end if
         goto 400
c        end while



c        -----   Update Ufirst, Ulist, Lfirst, Llist   -----
c

c        Update Lfirst, Llist 
c
c        n         size of the problem
c        k         current step of the update procedure
c        jlu(k)    start of column k of L, regular part
c        jlu       index array
c        jw(n3+1)  pointers to the first space behind any column of L
c                  (points behind the space of the regular part)
c        jw(n5+1)  linked list for the nonzeros of L in row k
c                  (regulREALS ABSFNAME, SQRTFNAMEar part)
c        jw        first nonzero entry in L(k:n,i)
c                  (regular part)
 410     call iluclist(n,k,jlu(k),jlu,jw(n3+1),jw(n5+1),jw)

c        Tismenetsky update
         if (sctype.gt.0) then

c           n         size of the problem
c           k         current step of the update procedure
c           jw(n3+k)  start of column k of L, epsilon size part
c           jlu       index array
c           ju        pointers to the first space behind any column of L
c                     (points behind the space of the epsilon part)
c           jw(n9+1)  linked list for the nonzeros of L in row k
c                     (epsilon size part)
c           jw(n7+1)  first nonzero entry in L(k:n,i)
c                     (epsilon size part)
            call iluclist(n,k,jw(n3+k),jlu,ju,jw(n9+1),jw(n7+1))
         end if


c        Update Ufirst, Ulist 
c
c        n         size of the problem
c        k         current step of the update procedure
c        ju(k)     start of row k of U, regular part
c        jlu       index array
c        jw(n4+1)  pointers to the first space behind any row of U
c                  (points behind the space of the regular part)
c        jw(n6+1)  linked list for the nonzeros of U in column k
c                  (regular part)
c        jw(n2+1)  first nonzero entry in U(i,k:n)
c                  (regular part)
         call iluclist(n,k,ju(k),jlu,jw(n4+1),jw(n6+1),jw(n2+1))


c        Tismenetsky update
         if (sctype.gt.0) then
c           n         size of the problem
c           k         current step of the update procedure
c           jw(n4+k)  start of row k of U, epsilon size part
c           jlu       index array
c           jlu(2)    pointers to the first space behind any row of U
c                     (points behind the space of the epsilon size part)
c           jw(n10+1) linked list for the nonzeros of U in column k
c                     (epsilon size part)
c           jw(n8+1)  first nonzero entry in U(i,k:n)
c                     (epsilon size part)
            call iluclist(n,k,jw(n4+k),jlu,jlu(2),jw(n10+1),jw(n8+1))
         end if

 110  continue
      

c     remove the embedded small entries
      if (sctype.gt.0) then
         len=0
         do 600 k=1,n-1
c           gap behind column k of L
            len=len+ju(k)-jw(n3+k)
c           shift U part
            do 610 j=ju(k),jw(n4+k)-1
               alu(j-len)=alu(j)
               jlu(j-len)=jlu(j)
 610        continue
            ju(k)=ju(k)-len
c           gap behind column k of U
            len=len+jlu(k+1)-jw(n4+k)
c           shift L part
            do 620 j=jlu(k+1),jw(n3+k+1)-1
               alu(j-len)=alu(j)
               jlu(j-len)=jlu(j)
 620        continue
            jlu(k+1)=jlu(k+1)-len
 600     continue
c        adjust final pointers
         ju(n)=ju(n)-len
         jlu(n+1)=jlu(n+1)-len
      end if



c     replace estimates for the ROWS of L^{-1} and COLUMNS of U^{-1}
c     by estimates for COLUMNS of L^{-1} and ROWS of U^{-1}. This 
c     information may be useful when ILUC is applied for a second time
c     
c     To do this we solve a linear system with L^T and right hand side 
c     (+/-1,...,+/-1)^T an analogously with U and right hand side
c     (+/-1,...,+/-1)^T
      if (droptype.gt.0 .and. invinfo.eq.0) then


c        -----   dealing with the lower triangular part   -----
c
c        note that L is stored by columns. This is an excellent 
c        situation if we want to do a backward solve with L^T but it is
c        less helpful to estimate the column norms of L^{-1}
c
c        set up linked list to access the rows of L correctly, starting 
c        with row n and going backwards
c
c        jw(n+1:2n)       
c        jw(2n+1:3n) head of the linked list for the rows of L
c        jw(3n+1:4n) linked list for the terminating rows of L at step k
c                    starting from the last row
c        jw(4n+1:5n) pointer to the last entry at step k
         do 800 k=1,n
c           clear head of the linked list (empty) 
            jw(n2+k)=0
c           clear inverse information
            w(n+k)=0.0d0
c           init counter array
            jw(n7+k)=0
 800     continue
         if (improved.gt.0) then
            do 805 k=1,n
c              clear improved inverse information
               w(n3+k)=0.0d0
 805        continue
         end if
         do 810 i=n,1,-1
c           pointer to the last nonzero element in column i
            j=ju(i)-1
c           row index k of  L(k,i)
            k=jlu(j)
c           we have to make sure that we are still inside column i
            if (j.ge.jlu(i)) then
c              pointer to the current last nonzero entry in column i
               jw(n4+i)=j
c              add new entry to the head of the list
               jw(n3+i)=jw(n2+k)
               jw(n2+k)=i
            end if
 810     continue


c        main loop for backward solve with L^T
         do 820 k=n,1,-1


c           extract row k of L
            len=0
c           if L(k,1:k-1) is nonempty, get the entry point to the
c           linked list of row k
            i=jw(n2+k)
c           while i>0         
 830           if (i.le.0) goto 840

               len=len+1
c              add i to the list of nonzeros
               jw(n+len)=i
c              pointer to L(k,i)
               j=jw(n4+i)
c              extract numerical value
               w(i)=alu(j)
c              store previous row from the linked list
               m=jw(n3+i)

c              downdate row information
               jw(n4+i)=jw(n4+i)-1
c              pointer to the previous nonzero element in column i
               j=jw(n4+i)
c              column index l of L(l,i)
               l=jlu(j)
c              we have to make sure that we are still inside column i
               if (j.ge.jlu(i)) then 
c                 add new entry to the head of the list
                  jw(n3+i)=jw(n2+l)
                  jw(n2+l)=i
               end if

c              recover previous row entry
               i=m
            goto 830
c           end while


c           estimate column norms of L^{-1}
c           try +/-1 as k-th component of the right hand side
 840        signum=1.0d0
c#if !defined _DOUBLE_REAL_ && !defined _SINGLE_REAL_
c$$$            mup=0.0d0
c$$$            j=1
c$$$            do i=1,len
c$$$c              column index l
c$$$               l=jw(n+i)
c$$$               if (dabs(w(n+l))+dabs(w(l)*alu(l)).gt.mup) then 
c$$$                  mup=dabs(w(n+l))+dabs(w(l)*alu(l))
c$$$                  j=i
c$$$               endif
c$$$            enddo
c$$$c           choose the sign such that component l is maximized
c$$$            if (len.gt.0) then
c$$$               l=jw(n+j)
c$$$               if (      w(n+l).ne.0.0d0 
c$$$     +              .and. w(l)*alu(l).ne.0.0d0) then
c$$$                  signum=(w(n+l)/dabs(w(n+l)))
c$$$     +                 *((w(l)*alu(l))/dabs(w(l)*alu(l)))
c$$$               endif
c$$$            endif
c#else
c#endif
            xp=( SIGNUM-w(n+k))
            xm=(-SIGNUM-w(n+k))
c           for both cases estimate the 1-norm of L^{-T} by evaluating
c           L(k:n,1:k-1)^T*L(k:n,k:n)^{-T}*rhs(k:n)
            mup=0.0d0
            mum=0.0d0
            do 850 i=1,len
c              column index l
               l=jw(n+i)
               mup=mup+dabs(w(n+l)+xp*w(l)*alu(l))
               mum=mum+dabs(w(n+l)+xm*w(l)*alu(l))
 850        continue
            if (mup.ge.mum) then
               x=xp
            else
               x=xm
            end if

c           number of peaks in column k
            m=jw(n7+k)
c           will the diagonal entry become a peak of row k
c           this is the case if the average of peaks is at most 1
            if (dabs(w(n+k)).le.dble(m)) m=m+1
c           store new number of peaks
            jw(n7+k)=m
            do 860 i=1,len
c              column index l
               l=jw(n+i)
               y=x*w(l)*alu(l)
c              will we have a serious contribution to the rank-1 update
c              of L^{-1} in row l?
c              the new average of peaks |y|/m caused by the rank-1
c              update is at least as much as the current average of
c              peaks |w(n+l)|/jw(n7+l) in row l
               if (dabs(y)*dble(jw(n7+l)).ge.dabs(w(n+l))*dble(m))
     +             jw(n7+l)=m
               w(n+l)=w(n+l)+y
 860        continue
            w(n+k)=dabs(xm)
            if (dabs(xp).gt.(w(n+k))) w(n+k)=dabs(xp)

c           improved estimate using a different right hand side
            if (improved.gt.0) then
c              try +/-1 as k-th component of the right hand side
               xp=( SIGNUM-w(n3+k))
               xm=(-SIGNUM-w(n3+k))
c              for both cases count the number of serious changes by evaluating
c              L(k:n,1:k-1)^T*L(k:n,k:n)^{-T}*rhs(k:n)
               j=0
               m=0
               do 855 i=1,len
c                 column index l
                  l=jw(n+i)
                  ax=dabs(w(n3+l))
                  ay=dabs(w(n3+l)+xp*w(l)*alu(l))
c                 entry seriously increases                  
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  j=j+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  j=j-1
                  ay=dabs(w(n3+l)+xm*w(l)*alu(l))
c                 entry seriously increases              
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  m=m+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  m=m-1
 855           continue
               if (j.ge.m) then
                  x=xp
               else
                  x=xm
               end if
               do 865 i=1,len
c                 column index l
                  l=jw(n+i)
                  w(n3+l)=w(n3+l)+x*w(l)*alu(l)
 865           continue
               if (dabs(xm).gt.(w(n+k))) w(n+k)=dabs(xm)
               if (dabs(xp).gt.(w(n+k))) w(n+k)=dabs(xp)
            end if
c           estimate the infinity norm from the estimate of the 1-norm
c           by dividing the 1-norm by the estimated number of essential
c           nonzeros in row k
c           on the average we expect that half of the off-diagonal
c           entries may cancel as a result of using only one test vector
            if (jw(n7+k).gt.2) w(n+k)=2*w(n+k)/dble(jw(n7+k))
            if ((w(n+k)).lt.1.0d0) w(n+k)=1.0d0
c           end estimate column norms of L^{-1}

 820     continue
c        end main loop



c        -----   dealing with the upper triangular part   -----
c
c        note that U is stored by rows. This is an excellent situation
c        if we want to do a backward solve with U but it is less 
c        helpful to estimate the row norms of U^{-1}
c
c        set up linked list to access the columns of U correctly,
c        starting with row n and going backwards
c
c        jw(2n+1:3n) head of the linked list for the columns of U
c        jw(3n+1:4n) linked list for the terminating columns of U at 
c                    step k starting from the last column
c        jw(4n+1:5n) pointer to the last entry at step k
         do 900 k=1,n
c           clear head of the linked list (empty) 
            jw(n2+k)=0
c           clear inverse information
            w(n2+k)=0.0d0
c           init counter array
            jw(n8+k)=0
 900     continue
         if (improved.gt.0) then
            do 905 k=1,n
c              clear improved inverse information
               w(n4+k)=0.0d0
 905        continue
         end if
         do 910 i=n,1,-1
c           pointer to the last nonzero element in row i
            j=jlu(i+1)-1
c           column index k of U(i,k)
            k=jlu(j)
c           we have to make sure that we are still inside row i
            if (j.ge.ju(i)) then
c              pointer to the current last nonzero entry in row i
               jw(n4+i)=j
c              add new entry to the head of the list
               jw(n3+i)=jw(n2+k)
               jw(n2+k)=i
            end if
 910     continue


c        main loop for backward solve with U
         do 920 k=n,1,-1


c           extract column k of U
            len=0
c           if U(1:k-1,k) is nonempty, get the entry point to the
c           linked list of row k
            i=jw(n2+k)
c           while i>0         
 930           if (i.le.0) goto 940

               len=len+1
c              add i to the list of nonzeros
               jw(n+len)=i
c              pointer to U(i,k)
               j=jw(n4+i)
c              extract numerical value
               w(i)=alu(j)
c              store previous column from the linked list
               m=jw(n3+i)

c              downdate row information
               jw(n4+i)=jw(n4+i)-1
c              pointer to the previous nonzero element in row i
               j=jw(n4+i)
c              row index l of U(i,l)
               l=jlu(j)
c              we have to make sure that we are still inside row i
               if (j.ge.ju(i)) then 
c                 add new entry to the head of the list
                  jw(n3+i)=jw(n2+l)
                  jw(n2+l)=i
               end if

c              recover previous column entry
               i=m
            goto 930
c           end while


c           estimate row norms of U^{-1}
c           try +/-1 as k-th component of the right hand side
 940        signum=1.0d0
c#if !defined _DOUBLE_REAL_ && !defined _SINGLE_REAL_
c$$$            mup=0.0d0
c$$$            j=1
c$$$            do i=1,len
c$$$c              column index l
c$$$               l=jw(n+i)
c$$$               if (dabs(w(n2+l))+dabs(w(l)*alu(l)).gt.mup) then 
c$$$                  mup=dabs(w(n2+l))+dabs(w(l)*alu(l))
c$$$                  j=i
c$$$               endif
c$$$            enddo
c$$$c           choose the sign such that component l is maximized
c$$$            if (len.gt.0) then
c$$$               l=jw(n+j)
c$$$               if (      w(n2+l).ne.0.0d0 
c$$$     +              .and. w(l)*alu(l).ne.0.0d0) then
c$$$                  signum=(w(n2+l)/dabs(w(n2+l)))
c$$$     +                 *((w(l)*alu(l))/dabs(w(l)*alu(l)))
c$$$               endif
c$$$            endif
c#else
c#endif
            xp=( SIGNUM-w(n2+k))
            xm=(-SIGNUM-w(n2+k))
c           for both cases estimate the 1-norm of U^{-1} by evaluating
c           U(1:k-1,k:n)*U(k:n,k:n)^{-1}*rhs(k:n)
            mup=0.0d0
            mum=0.0d0
            do 950 i=1,len
c              column index l
               l=jw(n+i)
               mup=mup+dabs(w(n2+l)+xp*w(l)*alu(l))
               mum=mum+dabs(w(n2+l)+xm*w(l)*alu(l))
 950        continue
            if (mup.ge.mum) then
               x=xp
            else
               x=xm
            end if

c           number of peaks in column k
            m=jw(n8+k)
c           will the diagonal entry become a peak of column k
c           this is the case if the average of peaks is at most 1
            if (dabs(w(n2+k)).le.dble(m)) m=m+1
c           store new number of peaks
            jw(n8+k)=m
            do 960 i=1,len
c              column index l
               l=jw(n+i)
               y=x*w(l)*alu(l)
c              will we have a serious contribution to the rank-1 update
c              of U^{-1} in column l?
c              the new average of peaks |y|/m caused by the rank-1
c              update is at least as much as the current average of
c              peaks |w(n2+l)|/jw(n8+l) in column l
               if (dabs(y)*dble(jw(n8+l)).ge.dabs(w(n2+l))*dble(m))
     +             jw(n8+l)=m
               w(n2+l)=w(n2+l)+y
 960        continue
            w(n2+k)=dabs(xm)
            if (dabs(xp).gt.(w(n2+k))) w(n2+k)=dabs(xp)

c           improved estimate using a different right hand side
            if (improved.gt.0) then
c              try +/-1 as k-th component of the right hand side
               xp=( SIGNUM-w(n4+k))
               xm=(-SIGNUM-w(n4+k))
c              for both cases count the number of serious changes by evaluating
c              U(1:k-1,k:n)*U(k:n,k:n)^{-1}*rhs(k:n)
               j=0
               m=0
               do 955 i=1,len
c                 column index l
                  l=jw(n+i)
                  ax=dabs(w(n4+l))
                  ay=dabs(w(n4+l)+xp*w(l)*alu(l))
c                 entry seriously increases                  
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  j=j+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  j=j-1
                  ay=dabs(w(n4+l)+xm*w(l)*alu(l))
c                 entry seriously increases              
                  if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  m=m+1
c                 entry seriously decreases              
                  if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  m=m-1
 955           continue
               if (j.ge.m) then
                  x=xp
               else
                  x=xm
               end if
               do 965 i=1,len
c                 column index l
                  l=jw(n+i)
                  w(n4+l)=w(n4+l)+x*w(l)*alu(l)
 965           continue
               axp=dabs( SIGNUM-w(n4+k))
               axm=dabs(-SIGNUM-w(n4+k))
               if (axm.gt.(w(n2+k))) w(n2+k)=axm
               if (axp.gt.(w(n2+k))) w(n2+k)=axp
            end if
c           estimate the infinity norm from the estimate of the 1-norm
c           by dividing the 1-norm by the estimated number of essential
c           nonzeros in column k
c           on the average we expect that half of the off-diagonal
c           entries may cancel as a result of using only one test vector
            if (jw(n8+k).gt.2) w(n2+k)=2*w(n2+k)/dble(jw(n8+k))
            if ((w(n2+k)).lt.1.0d0) w(n2+k)=1.0d0
c           end estimate norm of the inverse

 920     continue
c        end main loop

      end if




      ierr = 0
      if (pivottype.eq.0 .and. zeropivots.gt.0) then
c      if (zeropivots.gt.0) then
         write (6,'(A,I6,A)') '!!! Warning: ',zeropivots,
     +         ' zero pivots occured and have been shifted away!!!'
      end if
      return
c     END regular routine


c     -----   ERROR handling   -----
c

c     zero diagonal pivot
 990  ierr=k
      return

c
c     incomprehensible error. Matrix must be wrong.
c     
 991  ierr = -1
      return
c     
c     insufficient storage in L.
c     
 992  ierr = -2
      return
c     
c     insufficient storage in U.
c     
 993  ierr = -3
      return
c     
c     illegal lfil entered.
c     
 994  ierr = -4
      return
c----------------end-of-iluc--------------------------------------------
c-----------------------------------------------------------------------
      end
