c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
      subroutine piluc(n,a,ja,ia,lfilv,droptols,condest,nLU,
     +     param,p,invq,alu,jlu,ju,iwk,w,jw,ierr)
c-----------------------------------------------------------------------
      implicit none 
      integer n,iwk,nLU,p(n),invq(n),
     +        ja(*),ia(n+1),jlu(iwk),ju(n),jw(*),lfilv(2),ierr,param
      double precision droptols(3),condest
      double precision a(*),alu(iwk),w(*)
c----------------------------------------------------------------------*
c!*           *** PILUC, PARTIAL ILUC preconditioner ***               *
c                                                                      *
c    PILUC factors a general matrix (may be permuted) partially        *
c                   / L  0\ /D 0\ /U F_U\                              *
c    i.e. P^T A Q ~ |     | |   | |     |                              *
c                   \E_L I/ \0 S/ \0  I /                              *
c    The ILU uses diagonal pivoting to keep the inverse triangular     *
c    factors bounded                                                   *
c                                                                      *
c PILUC goes far beyond the simple single-level ILUC by introducing    *
c    additional features                                               *
c  - row and column permutations                                       *
c  - a PARTIAL ILUC decomposition instead of a full decomposition,     *
c    i.e. the decomposition is terminated on an earlier stage          *
c  - diagonal pivoting, i.e. at step k of the algorithm, column/row k  *
c    are skipped and pushed to the end, if the norm of L^{-1} or U^{-1}*
c    exceeds a prescribed bound                                        *
c                                                                      *
c Further options.                                                     *
c  - After the partial decomposition the approximate Schur complement  *
c    can be provided                                                   *
c  - diagonal compensation is offered                                  *
c  - as approximate Schur complement either the standard (simple)      *
c    approximate Schur complement can be used, or the more precise (and*
c    more expensive) Tismenetsky-like approximate Schur complement can *
c    be computed                                                       *
c----------------------------------------------------------------------*
c Code written by Matthias Bollhoefer, August 23, 2003                 *
c alternative Schur complement added February 2004                     *
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
c lfilv     array of integer. The fill-in parameters. Each column of L and each
c           row of U will have a maximum of lfilv(1) elements (excluding the
c           diagonal element). 
c           Each row of the approximate Schur complement will have at most
c           lfilv(2) entries.
c           lfilv(1),lfilv(2) must be .ge. 0.
c
c
c droptols  real array of size 2. 
c           droptols[1] sets the threshold for dropping small terms in the
c           factorization. See below for details on dropping strategy.
c           droptols[2] is used to drop entries from the Schur complement
c
c  
c iwk       integer. The lengths of arrays alu and jlu. If the arrays
c           are not big enough to store the ILU factorizations, ilut
c           will stop with an error message. 
c
c param     integer. Options of piluc (to be read bitwise)
c           bit 0
c            0   simple dual threshold dropping strategy   
c            1   inverse based dropping strategy
c           bit 2
c            0   simple Schur complement, very sparse but less accurate
c                version
c            4   Tismenetsky-like Schur complement, more dense but the 
c                error is squared
c           bit 4
c            0   simple inverse-based dropping strategy is used
c           16   inverse based dropping strategy is improved by a more 
c                precise estimate of the inverse
c           bit 5
c            0   no diagonal compensation
c           32   diagonal compensation is used, i.e., we ensure that the
c                ILU satisfies LU=A+E, where E*1=0 (1 denotes the vector
c                with all entries equal to 1)
c           bit 6
c            0   skipped entries are kept in the partial ILU
c           64   skipped entries are removed from the partial ILU
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
c jw        integer work array of length 15*n (if bit 2 is NOT set).
c           Then length is 21*n, if bit 2 is set.
c 
c           note that some variables share the same array. There is
c           no memory conflict because these variables access different
c           parts of the array at step k
c
c           jw(1:n)      index indicator array.
c
c           jw(n+1:2n)   list of nonzero indices
c        
c           jw(2n+1:3n)  head of the linked list for the columns of A.
c                        on entry to step k only jw(2n+k:3n) is
c                        referenced, after that only jw(2n+k+1:3n) is
c                        needed
c
c           jw(3n+1:4n)  linked list for the leading columns of A
c                        (A is stored by rows)
c
c           jw(4n+1:5n)  pointer to the first entry of any row at step k
c
c           jw(5n+1:6n)  linked list to the nonzero elements in row k of
c                        L (although L is stored by columns). jw(5n+k) 
c                        contains the reference of the first nonzero
c                        entry, jw(5n+jw(5n+k)) the second one and so on
c                        until a zero is reached which indicates the end
c
c           jw(na+1:na+n)1. part of the algorithm:
c                        pointer to first element of L(k:n,j) for 1<=j<k
c                        on entry to step k, only jw(na+1:na+k-1) is 
c                        referenced, at the end (in `iluclist'),
c                        jw(na+k) is also set. Only non-skipped components
c                        are referenced
c                        2. part of the algorithm:
c                        pointer to the current first skipped entry in
c                        column k of L (k=1,...,nLU) regular part
c                        (at this stage the skipped entries follow those
c                        entries that are kept)
c
c           jw(6n+1:7n)  linked list to the nonzero elements in column k
c                        of U (although U is stored by rows). jw(3n+k) 
c                        contains the reference of the first nonzero
c                        entry, jw(6n+jw(6n+k)) the second one and so on
c                        until a zero is reached which indicates the end
c
c           jw(2n+1:3n)  1. part of the algorithm:
c                        pointer to first element of U(j,k:n) for 1<=j<k
c                        on entry to step k, only jw(2n+1:2n+k-1) is 
c                        referenced, at the end (in `iluclist'), 
c                        jw(2n+k) is also set. Only non-skipped components
c                        are referenced
c                        2. part of the algorithm:
c                        pointer to the current first SKIPPED entry in
c                        row k of U (k=1,...,nLU) regular part
c                        (at this stage the skipped entries follow those
c                         entries that are kept)
c
c           jw(7n+1:8n)  number of nonzeros for any row of A(p,q), downdated
c                        during the algorithm. In step k only jw(7n+k:8n)
c                        is used. In addition jw(n7+i) for any skipped row
c                        i is used                                          
c
c           jw(8n+1:9n)  number of nonzeros for any column of A(p,q), 
c                        downdated during the algorithm. In step k only 
c                        jw(8n+k:9n) is used. In addition jw(n8+i) for any 
c                        skipped column i is used                         
c
c           jw(nb+1:nb+n)additional auxiliary pointer to the
c                        free space behind the regular part of L.
c                        on entry to step k, only jw(nb+1:nb+k-1) is
c                        referenced, later on when sparsifying column k
c                        of L, jw(nb+k) is set                         
c           jw(nd+1:nd+n)additional auxiliary pointer to the
c                        free space behind the regular part of U.
c                        on entry to step k, only jw(nd+1:nd+k-1) is
c                        referenced, later on when sparsifying row k
c                        of U, jw(nd+k) is set
c
c           jw(ne+1:ne+n)counter for the number of essential nonzeros in
c                        each row of L^{-1}, used to estimate the
c                        infinity norm based on the 1-norm estimate that
c                        is computed on entry to step k, only
c                        jw(ne+k:ne+n) is referenced, later on after
c                        sparsifying jw(ne+k) is no longer needed
c           
c           jw(nf+1:nf+n)1. part of the algorithm:
c                        counter for the number of essential nonzeros in
c                        each column of U^{-1}, used to estimate the
c                        infinity norm based on the 1-norm estimate that
c                        is computed on entry to step k, only
c                        jw(8n+k:9n) is referenced, later on after
c                        sparsifying jw(8n+k) is no longer needed
c                        2. part of the algorithm:
c                        pointer to the current first skipped entry in
c                        row k of U (k=1,...,nLU), epsilon size part
c                        (at this stage the skipped entries follow those
c                         entries that are kept)
c
c           
c           if bit 2 of param is set:
c           jw(9n+1:10n) linked list to the nonzero elements in row k of
c                        L, part with epsilon size values (although L is
c                        stored by columns). jw(9n+k) contains the
c                        reference of the first nonzero entry,
c                        jw(9n+jw(9n+k)) the second one and so on 
c                        until a zero is reached which indicates the end
c           jw(7n+1:8n)  1. part of the algorithm:
c                        pointer to first element of L(k:n,j) for j<k,
c                        epsilon size part.
c                        on entry to step k, only jw(7n+1:7n+k-1) is 
c                        referenced, at the end in `iluclist', jw(7n+k)
c                        is also set
c                        2. part of the algorithm:
c                        pointer to the current first SKIPPED entry in
c                        column k of L (k=1,...,nLU), epsilon size part
c                        (at this stage the skipped entries follow those
c                         entries that are kept)
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
c           additional auxilliary vectors to store skipped entries
c           if bit 2 of param is NOT set:     if bit 2 of param IS set:
c                  na= 9n                            na=11n        
c                  nb= 7n                            nb=17n
c                  nc=10n                            nc=12n             
c                  nd= 8n                            nd=18n
c                  ne=13n                            ne=13n
c                  nf=14n                            nf=14n
c                  nl=11n                            nl=13n             
c                  nu=12n                            nu=14n             
c                                                    el=15n             
c                                                    eu=16n             
c
c           jw(nc+1:nc+n) inverse mapping for all nodes that have been 
c                         skipped. nc is chosen dependent on the
c                         switches given by param
c
c           jw(nl+1:nl+n) number of skipped entries in each column of L.
c                         nl is chosen dependent on the switches given 
c                         by param. 
c           jw(nu+1:nu+n) number of skipped entries in each row of U.
c                         nu is chosen dependent on the switches given 
c                         by param. 
c
c           jw(el+1:el+n) number of skipped entries in each column of L,
c                         extended part (necessary if Tismenetsky update
c                         is required).
c                         el is chosen dependent on the switches given 
c                         by param. 
c           jw(eu+1:eu+n) number of skipped entries in each row of U,
c                         extended part (necessary if Tismenetsky update
c                         is required).
c                         eu is chosen dependent on the switches given 
c                         by param. 
c
c
c w         real work array of length n if bit 0 is NOT set, 5*n if bit
c           0 is set (inverse based dropping), 7*n if bit 0 and 4 are
c           both set
c
c           w(1:n)       used as buffer for the numerical values
c
c           if bit 0 is set to 1(or not set):
c           w(n+1:2n)    condition estimator for L
c           w(2n+1:3n)   condition estimator for U
c
c           if bit 0 is set to 1(or not set), AND bit 4 is set to 16:
c           w(3n+1:4n)   improved condition estimator for L
c           w(4n+1:5n)   improved condition estimator for U
c
cc           w(nrow+1:nrow+n) \  work arrays for the maximal error introduced
cc           w(ncol+1:ncol+n) /  by dropping in any row/column
cc           bit 4 set: nrow=5*n, ncol=6*n,
cc           otherwise: nrow=3*n, ncol=4*n,
c----------------------------------------------------------------------*
c     locals
      integer i,j,jj,k,l,m,r,n2,n3,n4,n5,n6,n7,n8,n9,n10,na,nc,nl,nu,
     +        el,eu,droptype,sctype,len,improved,ne,nf,nnzr,nnzc,
     +        ncol,nrow,simplesc,
     +        milu,nskipped,nb,nd,tailor, lfil,lfils
      doubleprecision    ax,ay,axp,axm,mup,mum,buffer,absaluk,
     +        droptolL,droptolU,sdroptol,droptol2,nup,num,droptol,
     +        Lmax,Umax,DLmax,DUmax,maxcondest
      logical skip,flag
      intrinsic max,min0
      doubleprecision x,y,xp,xm,signum,aluk,ialuk
      doubleprecision dabs,dsqrt
      external iluclist

      
c i,j,k,l,m        counters
c
c n2,...,n10       abbreviations for 2*n,...,10*n
c
c droptype         0 standard dropping,       1 inverse based dropping
c sctype           0 simple Schur complement, 1 Tismenetsky-like
c improved         0 simple inverse estimates 1 improved estimates
c milu             0 no diagonal comp.        1 diagonal comp. used
c tailor           0 coarse grid entries kept 1 coarse grid entries removed
c
c len              number of nonzeros in column/row k of L/U
c
c Lmax,Umax        maximum element of |L(k:n,k)*U(k,k)| and |U(k,k:n)|
c 
c x,xp,xm,mup,mum  used for inverse-based dropping
c
c aluk             |U(k,k)| 


      lfil =lfilv(1)
      lfils=lfilv(2)
c      print *,n,nLU,lfil,lfils

      if (lfil.lt.0) goto 994

c     drop tolerances
      droptol=droptols(1)
      droptol2=droptols(2)/condest
c      print *,droptols(1),droptols(2),condest
      maxcondest=1.0d0

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
      i=param
      droptype=mod(i,2)
c
c     bit 1
      i=i/2
c
c     bit 2
c     which kind of Schur complement do we use
c     0 simple, 1 Tismenetsky-like
      i=i/2
      sctype=mod(i,2)

c     bit 3
      i=i/2
c     bit 4
c     is an improved estimate desired?
c     0 no, 1 yes
      i=i/2
      improved=mod(i,2)

c     bit 5
c     is a diagonal compensation desired
c     0 no, 1 yes
      i=i/2
      milu=mod(i,2)

c     bit 6
c     should the ILU be tailored to non-skipped part
c     0 no, 1 yes
      i=i/2
      tailor=mod(i,2)

c     bit 7: FINAL_PIVOTING unused
      i=i/2

c     bit 8: ENSURE_SPD unused
      i=i/2

c     bit 9
c     should the remaining approximate Schur complement be computed
c     in a simple manner
c     0 no, 1 yes
      i=i/2
      simplesc=mod(i,2)

c     memory layout for the vectors of indices that handle skipped parts
c     of the incomplete LU factorization
c     if bit 2 of param IS set:
      if (sctype.gt.0) then
         nb=17*n
         nd=18*n
         na=11*n                 
         nc=12*n                 
         nl=13*n                 
         nu=14*n                 
         el=15*n                 
         eu=16*n                
         ne=19*n
         nf=20*n
c     if bit 2 of param is NOT set:
      else
         nb=n7
         nd=n8
         na=n9                 
         nc=n10
         nl=11*n  
         nu=12*n  
         ne=13*n
         nf=14*n
      end if
      if (improved.gt.0) then
         nrow=5*n
         ncol=6*n
      else
         nrow=3*n
         ncol=4*n
      end if 

c     ensure that the entries of A in any row are sorted in 
c     increasing order
      do 10 i=1,n
         j=ia(i)
         k=ia(i+1)-j
c        row i is empty
         if (k.le.0) then 
            if (k.eq.0) then
               goto 995
            else
               goto 991
            end if
         end if 
         call qqsort(a(j),ja(j),jw(n+1),k,invq)

c        column indices are out of range
         if (invq(ja(j)).lt.1 .or. invq(ja(j+k-1)).gt.n) then
            goto 991
         end if
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

c        clear counters for nonzero entries in any /column of A(p,q)
         jw(n8+i)=0
c
c        clear workspace for the numerical values
         w(i)=0.0d0
         w(nrow+i)=0.0d0
         w(ncol+i)=0.0d0

c        clear arrays for skipped parts of the incomplete LU factorization
         jw(na+i)=0
         jw(nc+i)=0
         jw(nl+i)=0
         jw(nu+i)=0
 10   continue

c     clear estimates for the norm of the inverse
      do 20 i=1,n
c        clear arrays to hold the estimates for the inverses
         w(n+i)=0.0d0
         w(n2+i)=0.0d0
c        init counter arrays
         jw(ne+i)=0
         jw(nf+i)=0
 20   continue
      if (improved.gt.0) then
         do 25 i=1,n
            w(n3+i)=0.0d0
            w(n4+i)=0.0d0
 25      continue
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

c           clear arrays for skipped parts of the incomplete LU factorization
            jw(el+i)=0
            jw(eu+i)=0
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
c        pointer to the first nonzero element in row p(i)
         j=ia(p(i))
c        first column index k of  A(p(i),q(k))
         k=invq(ja(j))
c        we have to make sure that we are still inside row p(i)
         if (j.lt.ia(p(i)+1)) then
c           pointer to the current first nonzero entry in row i
            jw(n4+i)=j
c           add new entry to the head of the list
            jw(n3+i)=jw(n2+k)
            jw(n2+k)=i
c           store number of nonzeros in row i of A(p,q)
            jw(n7+i)=ia(p(i)+1)-j
         end if
c        while j<ia(p(i)+1)
 45      if (j.ge.ia(p(i)+1)) goto 50
c           store number of nonzeros in column k of A(p,q)
            k=invq(ja(j))
            jw(n8+k)=jw(n8+k)+1
            ax=dabs(a(j))
            w(nrow+i)=w(nrow+i)+ax
            w(ncol+k)=w(ncol+k)+ax
            j=j+1
         goto 45
c        end while
 50   continue



c     extract diagonal part of A(p,q) and store it in alu(1:n)
      if (iwk.lt.n) goto 992
      do 80 i=1,n
         alu(i)=0.0d0
         k=ia(p(i))
         l=ia(p(i)+1)
c        while k<l and invq(ja(k))<i
 90         if (k.ge.l .or. invq(ja(k)).ge.i) goto 100
            k=k+1
         goto 90
c        end while
 100     if (k.lt.l .and. invq(ja(k)).eq.i) alu(i)=a(k)
 80   continue


c     initial values for jlu, jlu(1:n+1) are used as pointers to point
c     to the L part, so the indices start at n+2
      jlu(1)=n+2
      if (iwk.lt.n+1) goto 992


      nskipped=0
c     main loop
      do 110 k=1,nLU

c        initially, do not skip
         skip=.false.

c        -----   dealing with the lower triangular part   -----
c
c        extract skipped entries of column k
         len=0

c        extract strict lower triangular and skipped part of A, column k
c        if A(p(k+1:n),q(k)) is nonempty, get the entry point to the
c        linked list of column k
         i=jw(n2+k)
c        while i>0         
 120        if (i.le.0) goto 130

c           pointer to A(p(i),q(k))
            j=jw(n4+i)
c           column index l of  A(p(i),q(l))
            l=invq(ja(j))
c           store next row from the linked list
            m=jw(n3+i)

c           decide whether this entry has to be stored or not
            if (l.lt.i .or. jw(nc+i).gt.0) then 
               len=len+1
c              flag component i as nonzero
               jw(i)=len
c              add i to the list of nonzeros
               jw(n+len)=i
c              extract numerical value
               w(i)=a(j)
c              downdate number of nonzeros in row i of A(p,q)
               jw(n7+i)=jw(n7+i)-1
               w(nrow+i)=w(nrow+i)-dabs(a(j))
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
c           jw(nb+1)  pointers to the first space behind any column of L
c                     (behind the regular entries)
c           jw(n10+1) Ulist for the epsilon size part of U
c           jw(n8+1)  Ufirst for the epsilon size part of U
c           jw(na+1)  Lfirst for the regular part of L
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
c           jlu       pointers to the start of the L-part
c           jw(nl+1)  number of skipped entries, located at the start of
c                     every column
            call pilucupdate(n,k,alu,jlu,jlu(2),jw(nb+1),jw(n10+1),
     +                       jw(n8+1),jw(na+1),jw,len,w,jlu,jw(nl+1))

c           additional Tismenetsky updates using epsilon size previous
c           columns of L but regular elements of U
c           
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           jw(nd+1)  pointers to the first space behind any row of U
c                     (behind the regular entries)
c           ju        pointers to the first space behind any column of L
c                     (behind the epsilon size entries)
c           jw(n6+1)  Ulist for the regular part of U
c           jw(n2+1)  Ufirst for the regular part of U
c           jw(n7+1)  Lfirst for the epsilon size part of L
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
c           jw(nb+1)  pointers to the start of the epsilon size part of L
c           jw(el+1)  number of skipped (epsilon size) entries, located 
c                     at the start of every column
            call pilucupdate(n,k,alu,jlu,jw(nd+1),ju,jw(n6+1),jw(n2+1),
     +                       jw(n7+1),jw,len,w,jw(nb+1),jw(el+1))
         end if
         
c        regular update 
c        n         size of the problem
c        k         current step of the update
c        alu       numerical values
c        jlu       associated indices
c        jw(nd+1)  pointers to the first space behind any row of U
c                  (behind the regular entries)
c        jw(nb+1)  pointers to the first space behind any column of L
c                  (behind the regular entries)
c        jw(n6+1)  Ulist for the regular part of U
c        jw(n2+1)  Ufirst for the regular part of U
c        jw(na+1)  Lfirst for the regular part of L
c        jw        indices of nonzero entries and associated list
c        len       length of this list
c        w         numerical values
c        jlu       pointers to the start of the L-part
c        jw(nl+1)  number of skipped entries, located at the start of
c                  every column
         call pilucupdate(n,k,alu,jlu,jw(nd+1),jw(nb+1),jw(n6+1),
     +                    jw(n2+1),jw(na+1),jw,len,w,jlu,jw(nl+1))

c        position where the next row of U starts
         ju(k)=jlu(k)+len
         if (ju(k)-1.gt.iwk) goto 992
c        Compute maximal entry in absolute value of column k of L
         Lmax=dabs(alu(k))
c        estimate for max_l |L(l,k)|/||S(l,k+1:n)||, where S is the actual
c        Schur complement
         DLmax=0.0d0
c        Check whether there are several large entries in L that may 
c        lead to several rows in L^{-1} with significant norm
         mup=0.0d0
         mum=condest*dabs(alu(k))*0.25d0
         do 135 j=1,len
            l=jw(n+j)
            if (dabs(w(l)).gt.Lmax) Lmax=dabs(w(l))
            if (dabs(w(l)).gt.mum) mup=mup+dabs(w(l))

c           absolute value of the diagonal entry at position l
            ax=dabs(alu(l))
c           use max {|D(l,l)|, |A(l,k+1:n)|/nnz(A(l,k+1:n))} as estimate
c           for row l of the Schur complement (not really a bound)
            if (jw(n7+l).gt.0)
     +         ax=max(ax,(w(nrow+l))/dble(jw(n7+l)))
            if (ax.eq.0.0d0) then
               DLmax=1.0d300
            else
               if (dabs(w(l)).gt.DLmax*ax) DLmax=dabs(w(l)/ax)
            end if
 135     continue

c        check for zero pivot or |L(k+1:n,k)| with several large components
         if (alu(k).eq.0.0d0 .or.mup>4.0d0*mum)skip=.true.

         aluk=alu(k)
c        invert diagonal entry
         if (aluk.ne.0.0d0) ialuk=1.0d0/aluk
c        for several estimates we still need |D(k,k)|
         absaluk=dabs(aluk)
c        copy buffer to jlu/alu
         j=1
         if (iwk.lt.ju(k)-1) goto 992
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
         if (.not. skip) then
            signum=1.0d0
c#if !defined _DOUBLE_REAL_ && !defined _SINGLE_REAL_
            mup=0.0d0
            j=jlu(k)
            do i=jlu(k),ju(k)-1
c              row index l
               l=jlu(i)
               if (dabs(w(n+l))+dabs(alu(i)) .gt. mup) then 
                  mup=dabs(w(n+l))+dabs(alu(i))
                  j=i
               endif
            enddo
c           choose the sign such that component l is maximized
            if (jlu(k).lt.ju(k)) then
               l=jlu(j)
               if (      w(n+l).ne.0.0d0 
     +              .and. alu(j).ne.0.0d0) then
                  signum=(w(n+l)/dabs(w(n+l)))
     +                 *((alu(j))/dabs(alu(j)))
               endif
            endif
c#else
c#endif
c           try +/-1 as k-th component of the right hand side
            xp=( SIGNUM-w(n+k))*ialuk
            xm=(-SIGNUM-w(n+k))*ialuk
c           for both cases estimate the 1-norm of L^{-1} by evaluating
c           L(k+1:n,1:k)*L(1:k,1:k)^{-1}*rhs(1:k)
            mup=0.0d0 
            mum=0.0d0
            nup=0.0d0
            num=0.0d0
            do 150 i=jlu(k),ju(k)-1
c              row index l
               l=jlu(i)
               ax=dabs(w(n+l)+xp*alu(i))
               nup=max(nup,ax)
               mup=mup+ax
               ax=dabs(w(n+l)+xm*alu(i))
               num=max(num,ax)
               mum=mum+ax
 150        continue
            if (mup.ge.mum) then
               x=xp
               axp=dabs( SIGNUM-w(n+k))
            else
               x=xm
               axp=dabs(-SIGNUM-w(n+k))
               nup=num
            end if
c           use a buffer to store x
c           if the improved estimate turns out to skip entry k although
c           the first estimate has not indicated this, then we have to
c           'undo' the update
            buffer=-x
c           does the norm estimate exceed the prescribed bound? 
            if (max(nup,axp).gt.condest) skip=.true.
         end if

c        number of peaks in row k
         m=jw(ne+k)
c        will the diagonal entry become a peak of row k
c        this is the case if the average of peaks is at most 1
         if (dabs(w(n+k)).le.dble(m)) m=m+1
c        store new number of peaks
         jw(ne+k)=m
         if (.not. skip) then 
            do 160 i=jlu(k),ju(k)-1
               l=jlu(i)
               y=x*alu(i)
c              will we have a serious contribution to the rank-1
c              update of L^{-1} in row l?
c              the new average of peaks |y|/m caused by the rank-1
c              update is at least as much as the current average of
c              peaks |w(n+l)|/jw(ne+l) in row l
               if (dabs(y)*dble(jw(ne+l)).ge.dabs(w(n+l))*dble(m))
     +            jw(ne+l)=m
               w(n+l)=w(n+l)+y
 160        continue
            axp=dabs( SIGNUM-w(n+k))
            axm=dabs(-SIGNUM-w(n+k))
            w(n+k)=axm
            if (axp.gt.axm) w(n+k)=axp
         else
            w(n+k)=1.0d0
         end if
c
c        improved estimate using a different right hand side
         if (improved.gt.0 .and. .not.skip) then
c           try +/-1 as k-th component of the right hand side
            xp=( SIGNUM-w(n3+k))*ialuk
            xm=(-SIGNUM-w(n3+k))*ialuk
c           for both cases count the number of serious changes by
c           evaluating L(k+1:n,1:k)*L(1:k,1:k)^{-1}*rhs(1:k)
            j=0
            m=0
            nup=0.0d0
            num=0.0d0
            do 155 i=jlu(k),ju(k)-1
c              row index l
               l=jlu(i)
               ax=dabs(w(n3+l))
               ay=dabs(w(n3+l)+xp*alu(i))
               nup=max(nup,ay)
c              entry seriously increases                  
               if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  j=j+1
c              entry seriously decreases              
               if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  j=j-1
               ay=dabs(w(n3+l)+xm*alu(i))
               num=max(num,ay)
c              entry seriously increases              
               if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  m=m+1
c              entry seriously decreases              
               if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  m=m-1
 155        continue
            if (j.ge.m) then
               x=xp
               axp=dabs( SIGNUM-w(n3+k))
            else
               x=xm
               axp=dabs(-SIGNUM-w(n3+k))
               nup=num
            end if
               
c           does the norm estimate exceed the prescribed bound? 
            if (max(nup,axp).gt.condest) skip=.true.

            if (.not. skip) then 
               do 165 i=jlu(k),ju(k)-1
c                 row index l
                  l=jlu(i)
                  w(n3+l)=w(n3+l)+x*alu(i)
 165           continue
               axp=dabs( SIGNUM-w(n3+k))
               axm=dabs(-SIGNUM-w(n3+k))
               if (axm.gt.(w(n+k))) w(n+k)=axm
               if (axp.gt.(w(n+k))) w(n+k)=axp
            else
               w(n+k)=1.0d0
c              'undo' update 
               do 166 i=jlu(k),ju(k)-1
                  l=jlu(i)
                  y=buffer*alu(i)
                  w(n+l)=w(n+l)+y
 166           continue
            end if
         end if
c        end improved estimate
c
c        estimate the infinity norm from the estimate of the 1-norm
c        by dividing the 1-norm by the estimated number of essential
c        nonzeros in row k
c        on the average we roughly assume that half of the off-diagonal
c        entries may cancel as a result of using only ONE test vector
         if (jw(ne+k).gt.2) w(n+k)=2*w(n+k)/dble(jw(ne+k))
         if ((w(n+k)).lt.1.0d0) w(n+k)=1.0d0
c        end estimate norm of the inverse 


c        -----   dealing with the upper triangular part   -----
c
         len=0
         do 230 l=ia(p(k)),ia(p(k)+1)-1
c           column index i of A(p(k),q(i))
            i=invq(ja(l))
c           extract strict upper triangular part of A(p,q), row k
c           in addition, take care for the skipped part
            if (jw(nc+i).gt.0 .or. i.gt.k) then
               len=len+1
c              flag component i as nonzero
               jw(i)=len
c              add i to the list of nonzeros
               jw(n+len)=i
c              extract numerical value
               w(i)=a(l)
c              downdate number of nonzeros in column i of A(p,q)
               jw(n8+i)=jw(n8+i)-1
               w(ncol+i)=w(ncol+i)-dabs(a(l))
            end if
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
c           jw(nd+1)  pointers to the first space behind any row of U
c                     (behind the regular entries)
c           jw(n9+1)  Llist for the epsilon size part of L
c           jw(n7+1)  Lfirst for the epsilon size part of L
c           jw(n2+1)  Ufirst for the regular part of U
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
c           ju        pointers to the start of the U-part
c           jw(nu+1)  number of skipped entries, located at the start of
c                     every row
            call pilucupdate(n,k,alu,jlu,ju,jw(nd+1),jw(n9+1),
     +                       jw(n7+1),jw(n2+1),jw,len,w,ju,jw(nu+1))

c           additional Tismenetsky updates using epsilon size previous
c           rows of U but regular elements of L
c           
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           jw(nb+1)  pointers to the first space behind any column of L
c                     (behind the regular entries)
c           jlu(2)    pointers to the first space behind any row of U
c                     (behind the epsilon size entries)
c           jw(n5+1)  Llist for the regular part of L
c           jw(na+1)  Lfirst for the regular part of L
c           jw(n8+1 ) Ufirst for the epsilon size part of U
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
c           jw(nd+1)  pointers to the start of the epsilon size part of U
c           jw(eu+1)  number of skipped epsilon size entries, located at
c                     the start of every row
            call pilucupdate(n,k,alu,jlu,jw(nb+1),jlu(2),jw(n5+1),
     +                       jw(na+1),jw(n8+1),jw,len,w,jw(nd+1),
     +                       jw(eu+1))
         end if
         
c        regular update 
c        n         size of the problem
c        k         current step of the update
c        alu       numerical values
c        jlu       associated indices
c        jw(nb+1)  pointers to the first space behind any column of L
c                  (behind the regular entries)
c        jw(nd+1)  pointers to the first space behind any row of U
c                  (behind the regular size entries)
c        jw(n5+1)  Llist for the regular part of L
c        jw(na+1)  Lfirst for the regular part of L
c        jw(n2+1)  Ufirst for the regular part of U
c        jw        indices of nonzero entries and associated list
c        len       length of this list
c        w         numerical values
c        ju        pointers to the start of the U-part
c        jw(nu+1)  number of skipped entries, located at the start of
c                  every row
         call pilucupdate(n,k,alu,jlu,jw(nb+1),jw(nd+1),jw(n5+1),
     +                    jw(na+1),jw(n2+1),jw,len,w,ju,jw(nu+1))

c        position where the next column of L starts
         jlu(k+1)=ju(k)+len
         if (jlu(k+1)-1.gt.iwk) goto 993
         j=1
         Umax=absaluk
c        estimate for max_l |U(k,l)|/||S(k+1:n,l)||, where S is the actual
c        Schur complement
         DUmax=0.0d0
c        Check whether there are several large entries in U that may 
c        lead to several columns in U^{-1} with significant norm
         mup=0.0d0
         mum=condest*dabs(alu(k))*0.25d0
         do 240 i=ju(k),jlu(k+1)-1
c           extract column index l from the list of nonzeros
            l=jw(n+j)
            if (dabs(w(l)).gt.Umax) Umax=dabs(w(l))
            if (dabs(w(l)).gt.mum)  mup=mup+dabs(w(l))
            
c           absolute value of the diagonal entry at position l
            ax=dabs(alu(l))
c           use max {|D(l,l)|, |A(k+1:n,l)|/nnz(A(k+1:n,l))} as estimate
c           for column l of the Schur complement (not really a bound)
            if (jw(n8+l).gt.0)
     +         ax=max(ax,(w(ncol+l))/dble(jw(n8+l)))
            if (ax.eq.0.0d0) then
               DUmax=1.0d300
            else
               if (dabs(w(l)).gt.DUmax*ax) DUmax=dabs(w(l)/ax)
            end if
            jlu(i)=l
c           extract numerical value
            alu(i)=w(l)
c           DON'T clear auxiliary space w(l) at this point, it is still
c           needed
c           clear flag
            jw(l)=0
            j=j+1
 240     continue

c        check for |U(k,k+1:n)| with severaql large components
         if (mup>4.0d0*mum) skip=.true.

c        estimate norm of the columns of U^{-1}
         if (.not.skip) then
            signum=1.0d0
c#if !defined _DOUBLE_REAL_ && !defined _SINGLE_REAL_
            mup=0.0d0
            j=ju(k)
            do i=ju(k),jlu(k+1)-1
c              column index l
               l=jlu(i)
               if (dabs(w(n2+l))+dabs(alu(i)) .gt. mup) then 
                  mup=dabs(w(n2+l))+dabs(alu(i))
                  j=i
               endif
            enddo
c           choose the sign such that component l is maximized
            if (ju(k).lt.jlu(k+1)) then
               l=jlu(j)
               if (     w(n2+l).ne.0.0d0 
     +              .and. alu(j).ne.0.0d0) then
                  signum=(w(n2+l)/dabs(w(n2+l)))
     +                 *((alu(j))/dabs(alu(j)))
               endif
            endif
c#else
c#endif
c           try +/-1 as k-th component of the right hand side
            xp=( SIGNUM-w(n2+k))*ialuk
            xm=(-SIGNUM-w(n2+k))*ialuk
c           for both cases estimate the 1-norm of U^{-T} by evaluating
c           U(1:k,k+1:n)^T*U(1:k,1:k)^{-T}*rhs(1:k)
            mup=0.0d0
            mum=0.0d0
            nup=0.0d0
            num=0.0d0
            do 250 i=ju(k),jlu(k+1)-1
c              column index l
               l=jlu(i)
               ax=dabs(w(n2+l)+xp*alu(i))
               nup=max(ax,nup)
               mup=mup+ax
               ax=dabs(w(n2+l)+xm*alu(i))
               num=max(ax,num)
               mum=mum+ax
 250        continue
            if (mup.ge.mum) then
               x=xp
               axp=dabs( SIGNUM-w(n2+k))
            else
               x=xm
               axp=dabs(-SIGNUM-w(n2+k))
               nup=num
            end if

c           use a buffer to store x
c           if the improved estimate turns out to skip entry k although
c           the first estimate has not indicated this, then we have to
c           'undo' the update
            buffer=-x
c           does the norm estimate exceed the prescribed bound? 
            if (max(nup,axp).gt.condest) skip=.true.
         end if
c        number of peaks in column k
         m=jw(nf+k)
c        will the diagonal entry become a peak of column k
c        this is the case if the average of peaks is at most 1
         if (dabs(w(n2+k)).le.dble(m)) m=m+1
c        store new number of peaks
         jw(nf+k)=m
         if (.not. skip) then 
            do 260 i=ju(k),jlu(k+1)-1
               l=jlu(i)
               y=x*alu(i)
c              will we have a serious contribution to the rank-1
c              update of U^{-1} in column l?
c              the new average of peaks |y|/m caused by the rank-1
c              update is at least as much as the current average of
c              peaks |w(n2+l)|/jw(nf+l) in column l
               if (dabs(y)*dble(jw(nf+l)).ge.dabs(w(n2+l))*dble(m)) 
     +            jw(nf+l)=m
                  w(n2+l)=w(n2+l)+y
 260        continue
            axp=dabs( SIGNUM-w(n2+k))
            axm=dabs(-SIGNUM-w(n2+k))
            w(n2+k)=axm
            if (axp.gt.axm) w(n2+k)=axp
         else
            w(n2+k)=1.0d0
         end if
c
c        improved estimate using a different right hand side
         if (improved.gt.0 .and. .not.skip) then
c           try +/-1 as k-th component of the right hand side
            xp=( SIGNUM-w(n4+k))*ialuk
            xm=(-SIGNUM-w(n4+k))*ialuk
c           for both cases count the number of serious changes by
c           evaluating U(1:k,k+1:n)^T*U(1:k,1:k)^{-T}*rhs(1:k)
            j=0
            m=0
            nup=0.0d0
            num=0.0d0
            do 255 i=ju(k),jlu(k+1)-1
c              column index l
               l=jlu(i)
               ax=dabs(w(n4+l))
               ay=dabs(w(n4+l)+xp*alu(i))
               nup=max(nup,ay)
c              entry seriously increases                  
               if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  j=j+1
c              entry seriously decreases              
               if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  j=j-1
               ay=dabs(w(n4+l)+xm*alu(i))
               num=max(num,ay)
c              entry seriously increases              
               if (ay.gt.2.0d0*ax .and. ay.gt.0.5)  m=m+1
c              entry seriously decreases              
               if (2.0d0*ay.lt.ax .and. ax.gt.0.5)  m=m-1
 255        continue
            if (j.ge.m) then
               x=xp
               axp=dabs( SIGNUM-w(n4+k))
            else
               x=xm
               axp=dabs(-SIGNUM-w(n4+k))
               nup=num
            end if
               
c           does the norm estimate exceed the prescribed bound? 
            if (max(nup,axp).gt.condest) skip=.true.

            if (.not. skip) then 
               do 265 i=ju(k),jlu(k+1)-1
                  l=jlu(i)
                  w(n4+l)=w(n4+l)+x*alu(i)
 265           continue
               axp=dabs( SIGNUM-w(n4+k))
               axm=dabs(-SIGNUM-w(n4+k))
               if (axm.gt.(w(n2+k))) w(n2+k)=axm
               if (axp.gt.(w(n2+k))) w(n2+k)=axp
            else
               w(n2+k)=1.0d0
c              'undo' update 
               do 263 i=ju(k),jlu(k+1)-1
                  l=jlu(i)
                  y=buffer*alu(i)
                  w(n2+l)=w(n2+l)+y
 263           continue
            end if
         end if
c        end improved estimate
c
c        estimate the infinity norm from the estimate of the 1-norm
c        by dividing the 1-norm by the estimated number of essential
c        nonzeros in column k
c        on the average we roughly assume that half of the off-diagonal
c        entries may cancel as a result of using only ONE test vector
         if (jw(nf+k).gt.2) w(n2+k)=2*w(n2+k)/dble(jw(nf+k))
         if ((w(n2+k)).lt.1.0d0) w(n2+k)=1.0d0
c        end estimate norm of the inverse 


         i=jw(n2+k)
c        while i>0         
 261     if (i.le.0) goto 262

c           pointer to A(p(i),q(k))
            j=jw(n4+i)
c           column index l of  A(p(i),q(l))
            l=invq(ja(j))
c           store next row from the linked list
            m=jw(n3+i)

c           decide whether this entry has to be stored or not
            if (l.lt.i .or. jw(nc+i).gt.0) then 
c              re-update number of nonzeros in row i of A(p,q)
               if (skip) then 
                  jw(n7+i)=jw(n7+i)+1
                  w(nrow+i)=w(nrow+i)+dabs(a(j))
               end if
            end if

c           update column information
            jw(n4+i)=j+1
c           pointer to the next nonzero element in row i
            j=jw(n4+i)
c           we have to make sure that we are still inside row i
            if (j.lt.ia(p(i)+1)) then
c              column index l of A(p(i),q(l))
               l=invq(ja(j))
c              add new entry to the head of the list
               jw(n3+i)=jw(n2+l)
               jw(n2+l)=i
            end if

c           recover next row entry
            i=m
         goto 261
c        end while



c        if step k has to be skipped due to a suitable criterion
 262     if (skip) then
            do 264 l=ia(p(k)),ia(p(k)+1)-1
c              column index i of A(p(k),q(i))
               i=invq(ja(l))
c              re-update number of nonzeros in column i of A(p,q)
               if (jw(nc+i).gt.0 .or. i.gt.k) then
                  jw(n8+i)=jw(n8+i)+1
                  w(ncol+i)=w(ncol+i)+dabs(a(l))
               end if
 264        continue

c           skip node k
            nskipped=nskipped+1
            jw(nc+k)=nskipped


c           permute row/column k behind the (possibly) already existing
c           skipped parts

c           -----   dealing with the lower triangular part   -----
c           additional Tismenetsky entries
            if (sctype.gt.0) then
c              linked list for the epsilon size part of L
               i=jw(n9+k)
c              while i>0
 266           if (i.eq.0) goto 267
c                 does there exist an entry in L(k:n,i)?
c                 first nonzero entry in the epsilon size part of L
                  l=jw(n7+i)
                  if (l.lt.ju(i)) then 
c                    if this is the case, is the first entry equal to k,
c                    otherwise we don't need changes since L(k,i)=0
c                    L(k,i)?
                     if (jlu(l).eq.k) then
c                       last skipped entry
                        j=jw(nb+i)+jw(el+i)
c                       swap indices
                        jlu(l)=jlu(j)
                        jlu(j)=k
c                       swap numerical values
                        x=alu(l)
                        alu(l)=alu(j)
                        alu(j)=x
c                       increment number of skipped entries
                        jw(el+i)=jw(el+i)+1
                     end if 
                  end if
                  i=jw(n9+i)
               goto 266
c              end while
            end if
c           linked list for the regular part of L
 267        i=jw(n5+k)
c           while i>0
 268        if (i.eq.0) goto 269
c              does there exist an entry in L(k:n,i)?
c              first nonzero entry in the regular part of L
               l=jw(na+i)
               if (l.lt.jw(nb+i)) then 
c                 if this is the case, is the first entry equal to k,
c                 otherwise we don't need changes since L(k,i)=0
c                 L(k,i)?
                  if (jlu(l).eq.k) then
c                    last skipped entry
                     j=jlu(i)+jw(nl+i)
c                    swap indices
                     jlu(l)=jlu(j)
                     jlu(j)=k
c                    swap numerical values
                     x=alu(l)
                     alu(l)=alu(j)
                     alu(j)=x
c                    increment number of skipped entries
                     jw(nl+i)=jw(nl+i)+1
                  end if 
               end if
               i=jw(n5+i)
            goto 268
c           end while
        
c           -----   dealing with the upper triangular part   -----
c           additional Tismenetsky entries
 269        if (sctype.gt.0) then
c              linked list for the epsilon size part of U
               i=jw(n10+k)
c              while i>0
 251           if (i.eq.0) goto 252
c                 does there exist an entry in U(i,k:n)?
c                 first nonzero entry in the epsilon size part of U
                  l=jw(n8+i)
                  if (l.lt.jlu(i+1)) then 
c                    if this is the case, is the first entry equal to k,
c                    otherwise we don't need changes since U(i,k)=0
c                    U(i,k)?
                     if (jlu(l).eq.k) then
c                       last skipped entry
                        j=jw(nd+i)+jw(eu+i)
c                       swap indices
                        jlu(l)=jlu(j)
                        jlu(j)=k
c                       swap numerical values
                        x=alu(l)
                        alu(l)=alu(j)
                        alu(j)=x
c                       increment number of skipped entries
                        jw(eu+i)=jw(eu+i)+1
                     end if 
                  end if
                  i=jw(n10+i)
               goto 251
c              end while
            end if
c           linked list for the regular part of U
 252        i=jw(n6+k)
c           while i>0
 253        if (i.eq.0) goto 254
c              does there exist an entry in U(i,k:n)?
c              first nonzero entry in the regular part of U
               l=jw(n2+i)
               if (l.lt.jw(nd+i)) then 
c                 if this is the case, is the first entry equal to k,
c                 otherwise we don't need changes since U(i,k)=0
c                 U(i,k)?
                  if (jlu(l).eq.k) then
c                    last skipped entry
                     j=ju(i)+jw(nu+i)
c                    swap indices
                     jlu(l)=jlu(j)
                     jlu(j)=k
c                    swap numerical values
                     x=alu(l)
                     alu(l)=alu(j)
                     alu(j)=x
c                    increment number of skipped entries
                     jw(nu+i)=jw(nu+i)+1
                  end if 
               end if
               i=jw(n6+i)
            goto 253
c           end while

 254     end if


c        -----   sparsify L and U   -----
c
c        drop tolerances
c
c        classical dropping
c        drop entries that are less than a tolerance droptol multiplied
c        by the absolute value of the diagonal entry
 273     droptolL=droptol*absaluk
         droptolU=droptolL
c        do we use inverse-based dropping?
         if (droptype.gt.0) then
            droptolL=droptolL/(w(n+k))
            droptolU=droptolU/(w(n2+k))
         end if 
         maxcondest=max(maxcondest,max((w(n+k)),(w(n2+k))))
         droptol2=droptols(2)/maxcondest
c        lower triangular part
c        separate nonzero entries of column k of L between those which
c        are greater than droptolL and those which are equal to or less
c        than droptolL (in absolute values)
         i=jlu(k)
         j=ju(k)
         DUmax=dabs(ialuk)*DUmax
         Umax =dabs(ialuk)*Umax
c        while i<j
 270        if (i.ge.j) goto 280
c           row index
            l=jlu(i)
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
            ax=dabs(alu(l))
            if (jw(n7+l).gt.0)
     +         ax=max(ax,(w(nrow+l))/dble(jw(n7+l)))

            if (dabs(alu(i)*Umax) .le.droptol2*ax
     +          .and. dabs(alu(i)*DUmax).le.droptol2
     +          .and. dabs(alu(i)).le.droptolL) then
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

         if (skip) then
c           clear L information and treat column k as if it were
c           not present
            ju(k)   =jlu(k)
            j=jlu(k)
         end if

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
c        save number of nonzeros in row k (non-Tismenetsky case)
         nnzr=jw(n7+k)
c        keep a pointer to the first space behind the regular part of L
         jw(nb+k)=j
c        sort regular part and epsilon size part separately
         call qsort2(alu(i),jlu(i),jw(n+1),j-i)
         call qsort2(alu(j),jlu(j),jw(n+1),len-j+i)
c        shift size for the U part
         m=ju(k)-jlu(k)-len


c        upper triangular part
c
c        restore the remaining lower triangular part to w
         do 295 i=jlu(k),jw(nb+k)-1
            l=jlu(i)
            w(l)=alu(i)
 295     continue
c


c        separate nonzero entries of row k of U between those
c        which greater than droptolU and those which equal to or less
c        than droptolU (all in absolute values)
c
         i=ju(k)
         j=jlu(k+1)
         DLmax=DLmax*dabs(ialuk)
         Lmax =Lmax *dabs(ialuk)
c        while i<j
 370        if (i.ge.j) goto 380
c           column index
            l=jlu(i)
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
            ax=dabs(alu(l))
            if (jw(n8+l).gt.0)
     +         ax=max(ax,(w(ncol+l))/dble(jw(n8+l)))

            if (dabs(Lmax *alu(i)).le.droptol2*ax
     +          .and. dabs(DLmax*alu(i)).le.droptol2
     +          .and. dabs(alu(i)).le.droptolU) then
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
 380     do 395 i=jlu(k),jw(nb+k)-1
            l=jlu(i)
            w(l)=0.0d0
 395     continue

         if (skip) then
c           clear U information and treat row k as if it were
c           not present
            jlu(k+1)=ju(k)
            j=ju(k)
         end if

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
         ialuk=1.0d0/alu(k)
         if (.not.skip) alu(k)=ialuk

c        Tismenetsky case
         if (sctype.gt.0 .and. .not.skip) then
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
               xp=xp*ialuk
               xm=xm*ialuk
               do 396 l=jlu(k),jw(nb+k)-1
                  alu(jlu(l))=alu(jlu(l))+alu(l)*xm
 396           continue
               do 397 l=jw(nb+k),ju(k)-1
                  alu(jlu(l))=alu(jlu(l))+alu(l)*xp
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
c        keep a pointer to the first space behind the regular part of U,
c        shifted by m
         j=j-m
c        save number of nonzeros in column k (non-Tismenetsky case)
         nnzc=jw(n8+k)
         jw(nd+k)=j
c        sort regular part and epsilon size part separately
         i=ju(k)
         call qsort2(alu(i),jlu(i),jw(n+1),j-ju(k))
         call qsort2(alu(j),jlu(j),jw(n+1),jlu(k+1)-j)


c        -----   update diagonal entries   -----
c
c        Tismenetsky update
         if (sctype.gt.0 .and. .not.skip) then
c           update - regular part and epsilon size part
            i=jlu(k)
            j=jw(nd+k)
c           while i<jw(nb+k) and j<jlu(k+1)
 420           if (i.ge.jw(nb+k) .or. j.ge.jlu(k+1)) goto 430
               l=jlu(i)
               m=jlu(j)
               if (l.eq.m) then
                  alu(l)=alu(l)-alu(i)*ialuk*alu(j)
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
 430        i=jw(nb+k)
            j=ju(k)
c           while i<ju(k) and j<jw(nd+k)
 440           if (i.ge.ju(k) .or. j.ge.jw(nd+k)) goto 450
               l=jlu(i)
               m=jlu(j)
               if (l.eq.m) then
                  alu(l)=alu(l)-alu(i)*ialuk*alu(j)
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
c        while i<jw(nb+k) and j<jw(nd+k)
 400        if (i.ge.jw(nb+k) .or. j.ge.jw(nd+k)) goto 399
            l=jlu(i)
            m=jlu(j)
            if (l.eq.m) then
               alu(l)=alu(l)-alu(i)*ialuk*alu(j)
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
c
c
c        -----   shuffle embedded skipped entries to the front   -----
c
c        L-part
 399     i=0
         i=0
         j=jlu(k)-1
c        scan column k
         do 401 l=jlu(k),jw(nb+k)-1
c           index m of L(m,k)
            m=jlu(l)
c           is this node NOT skipped?
c           use iw and w as buffer
            if (jw(nc+m).eq.0) then
               i=i+1
               jw(i)=m
               w(i)=alu(l)
            else 
c              shift skipped entries to the front
               j=j+1
               jlu(j)=m
               alu(j)=alu(l)
            end if
 401     continue
c        number of skipped nodes in column k of L
         jw(nl+k)=j-jlu(k)+1
c        put NON-skipped grid entries back to the end
         i=0
         j=j+1
c        while j<jw(nb+k)
 402     if (j.ge.jw(nb+k)) goto 403
            i=i+1
            m=jw(i)
            jlu(j)=m
            alu(j)=w(i)
            jw(i)=0
            w(i)=0.0d0
            j=j+1
         goto 402
c        end while
 403     if (sctype.gt.0) then
c           L-part, Tismenetsky updates
            i=0
            j=jw(nb+k)-1
c           scan column k, epsilon size part
            do 404 l=jw(nb+k),ju(k)-1
c              index m of L(m,k)
               m=jlu(l)
c              is this node NOT skipped?
c              use iw and w as buffer
               if (jw(nc+m).eq.0) then
                  i=i+1
                  jw(i)=m
                  w(i)=alu(l)
               else 
c                 shift skipped entries to the front
                  j=j+1
                  jlu(j)=m
                  alu(j)=alu(l)
               end if
 404        continue
c           number of skipped nodes in column k of L, epsilon size part
            jw(el+k)=j-jw(nb+k)+1
c           put NON-skipped entries back to the end
            i=0
            j=j+1
c           while j<ju(k)
 405        if (j.ge.ju(k)) goto 406
               i=i+1
               m=jw(i)
               jlu(j)=m
               alu(j)=w(i)
               jw(i)=0
               w(i)=0.0d0
               j=j+1
            goto 405
c           end while
         end if
c
c        shuffle embedded skipped entries to the front
c        U-part
 406     i=0
         j=ju(k)-1
c        scan column k
         do 407 l=ju(k),jw(nd+k)-1
c           index m of U(k,m)
            m=jlu(l)
c           is this node NOT skipped?
c           use iw and w as buffer
            if (jw(nc+m).eq.0) then
               i=i+1
               jw(i)=m
               w(i)=alu(l)
            else 
c              shift skipped entries to the front
               j=j+1
               jlu(j)=m
               alu(j)=alu(l)
            end if
 407     continue
c        number of skipped nodes in row k of U
         jw(nu+k)=j-ju(k)+1
c        put NON-skipped entries back to the end
         i=0
         j=j+1
c        while j<jw(nd+k)
 408     if (j.ge.jw(nd+k)) goto 409
            i=i+1
            m=jw(i)
            jlu(j)=m
            alu(j)=w(i)
            jw(i)=0
            w(i)=0.0d0
            j=j+1
         goto 408
c        end while
 409     if (sctype.gt.0) then
c           U-part, Tismenetsky updates
            i=0
            j=jw(nd+k)-1
c           scan row k, epsilon size part
            do 412 l=jw(nd+k),jlu(k+1)-1
c              index m of L(m,k)
               m=jlu(l)
c              is this node NOT skipped?
c              use iw and w as buffer
               if (jw(nc+m).eq.0) then
                  i=i+1
                  jw(i)=m
                  w(i)=alu(l)
               else 
c                 shift skipped entries to the front
                  j=j+1
                  jlu(j)=m
                  alu(j)=alu(l)
               end if
 412        continue
c           number of skipped nodes in row k of U, epsilon size part
            jw(eu+k)=j-jw(nd+k)+1
c           put NON-skipped entries back to the end
            i=0
            j=j+1
c           while j<jlu(k+1)
 413        if (j.ge.jlu(k+1)) goto 410
               i=i+1
               m=jw(i)
               jlu(j)=m
               alu(j)=w(i)
               jw(i)=0
               w(i)=0.0d0
               j=j+1
            goto 413
c           end while
         end if


c        -----   Update Ufirst, Ulist, Lfirst, Llist   -----
c

c        Update Lfirst, Llist 
c
c        n         size of the problem
c        k         current step of the update procedure
c        jlu(k)    start of column k of L, regular part shifted by the
c       +jw(nl+k)  number of embedded skipped entries   
c        jlu       index array
c        jw(nb+1)  pointers to the first space behind any column of L
c                  (points behind the space of the regular part)
c        jw(n5+1)  linked list for the nonzeros of L in row k
c                  (regular part)
c        jw(na+1)  first nonzero entry in L(k:n,i)
c                  (regular part)
 410     call iluclist(n,k,jlu(k)+jw(nl+k),jlu,jw(nb+1),jw(n5+1),
     +                 jw(na+1))

c        Tismenetsky update
         if (sctype.gt.0) then

c           save number of nonzeros in row k (Tismenetsky case)
            nnzr=jw(n7+k)
c           n         size of the problem
c           k         current step of the update procedure
c           jw(nb+k)  start of column k of L, epsilon size part shifted by 
c          +jw(el+k)  the number of embedded skipped entries  
c           jlu       index array
c           ju        pointers to the first space behind any column of L
c                     (points behind the space of the epsilon part)
c           jw(n9+1)  linked list for the nonzeros of L in row k
c                     (epsilon size part)
c           jw(n7+1)  first nonzero entry in L(k:n,i)
c                     (epsilon size part)
            call iluclist(n,k,jw(nb+k)+jw(el+k),jlu,ju,jw(n9+1),
     +                    jw(n7+1))
         end if


c        Update Ufirst, Ulist 
c
c        n         size of the problem
c        k         current step of the update procedure
c        ju(k)     start of row k of U, regular part shifted by 
c       +jw(nu+k)  the number of embedded skipped entries
c        jlu       index array
c        jw(nd+1)  pointers to the first space behind any row of U
c                  (points behind the space of the regular part)
c        jw(n6+1)  linked list for the nonzeros of U in column k
c                  (regular part)
c        jw(n2+1)  first nonzero entry in U(i,k:n)
c                  (regular part)
         call iluclist(n,k,ju(k)+jw(nu+k),jlu,jw(nd+1),jw(n6+1),
     +                 jw(n2+1))


c        Tismenetsky update
         if (sctype.gt.0) then
c           save number of nonzeros in column k (non-Tismenetsky case)
            nnzc=jw(n8+k)
c           n         size of the problem
c           k         current step of the update procedure
c           jw(nd+k)  start of row k of U, epsilon size part shifted by 
c          +jw(eu+k)  the number of embedded skipped entries
c           jlu       index array
c           jlu(2)    pointers to the first space behind any row of U
c                     (points behind the space of the epsilon size part)
c           jw(n10+1) linked list for the nonzeros of U in column k
c                     (epsilon size part)
c           jw(n8+1)  first nonzero entry in U(i,k:n)
c                     (epsilon size part)
            call iluclist(n,k,jw(nd+k)+jw(eu+k),jlu,jlu(2),jw(n10+1), 
     +                    jw(n8+1))
         end if

c        restore nonzero counter if column/row k has been skipped
         if (skip) then
            jw(n7+k)=nnzr
            jw(n8+k)=nnzc
         end if
 110  continue


c     skip selected columns
      l=1
      do k=1,nLU
c        this entry is a non-skipped entry
         if (jw(nc+k).eq.0) then
c           pointers to the actual first element in L/U (regular parts)
            jw(na+l)=jw(na+k)
            jw(n2+l)=jw(n2+k)
            l=l+1
         end if
      end do
      l=1
      m=1
      do 800 k=1,nLU
c        this entry is a non-skipped entry

         if (jw(nc+k).eq.0) then
c           L part, pointers
            jlu(l)=jlu(k)

c           U part, pointers
            ju(l)=ju(k)

c           diagonal part, numerical values 
            alu(l)=alu(k)

c           pointers to the actual first element in L/U (regular parts)
c            jw(na+l)=jw(na+k)
c            jw(n2+l)=jw(n2+k)

c           pointers to the actual first element in L/U (epsilon size parts)
            if (sctype.gt.0) then
               jw(n7+l)=jw(n7+k)
               jw(n8+l)=jw(n8+k)
            end if

c           pointers to the space behind L/U (regular parts)
            jw(nb+l)=jw(nb+k)
            jw(nd+l)=jw(nd+k)

c           store how many components a non-skipped entry has to advance
c           this gives the new label after reordering
            jw(n+k)=l
            l=l+1
         else
c           diagonal part, skipped numerical values 
            w(m)=alu(k)

c           number of remaining nonzeros in row/column k
c           use jw(na+...) and jw(n2+...) as buffers. Their values have
c           already been shifted in the previous loop
            jw(na+nLU-nskipped+m)=jw(n7+k)
            jw(n2+nLU-nskipped+m)=jw(n8+k)

c           1-norm of any skipped row/column shifted to the front
            w(nrow+m)=w(nrow+k)
            w(ncol+m)=w(ncol+k)

c           new position of k after (sym.) permutation
            jw(n+k)=nLU-nskipped+m
            m=m+1
         end if
 800  continue

c     shift final reference
      jlu(l)=jlu(nLU+1)
      do 815 m=1,nskipped
c        diagonal part, skipped numerical values 
         alu(nLU-nskipped+m)=w(m)
         w(m)=0.0d0

c        re-insert number of remaining nonzeros in row/column k
         jw(n7+nLU-nskipped+m)=jw(na+nLU-nskipped+m)
         jw(n8+nLU-nskipped+m)=jw(n2+nLU-nskipped+m)

c        1-norm of any skipped row/column shifted to the back
         w(nrow+nLU+1-m)=w(nrow+nskipped+1-m)
         w(ncol+nLU+1-m)=w(ncol+nskipped+1-m)

 815  continue
      do 810 k=nLU+1,n
         ju(k)=ju(nLU)
c        remaining entries stay where they are
         jw(n+k)=k
c        add the last n-nLU entries to the skipped part
         nskipped=nskipped+1
         jw(nc+k)=nskipped
 810  continue

      nLU=n-nskipped
      if (nLU.eq.0) return
      


c     list to the nonzero elements in row k of L, regular part (although
c     L is stored by columns). 
c     jw(n5+k)    contains the reference of the first nonzero entry,
c                 jw(n5+jw(n5+k)) the second one and so on 
c                 ... until a zero is reached which indicates the end
      do 820 k=1,n
         jw(n5+k)=0
 820  continue
c     additional Tismenetsky updates
c     list to the nonzero elements in row k of L, epsilon size part
c     (although L is stored by columns). 
c     jw(n9+k)    contains the reference of the first nonzero entry,
c                 jw(n9+jw(n9+k)) the second one and so on 
c                 ... until a zero is reached which indicates the end
      if (sctype.gt.0) then
         do 830 k=1,n
            jw(n9+k)=0
 830     continue
      end if

c     shuffle skipped entries to the end
      do k=1,nLU
c        L-part
         i=0
         j=jlu(k)-1
         r=jw(na+k)-1
         do 850 l=jlu(k),r
c           index m of L(m,k)
            m=jlu(l)
c           has this entry been skipped?
c           use jw and w as buff
            if (jw(nc+m).gt.0) then
               i=i+1
c              in addition to the shift we have to update the index
c              with respect to the new permutation
               jw(i)=jw(n+m)
               w(i) =alu(l)
            else 
c              shift entries
               j=j+1
c              in addition to the shift we have to update the index
c              with respect to the new permutation
               jlu(j)=jw(n+m)
               alu(j)=alu(l)
            end if
 850     continue
c        first skipped entry in column k of L, regular part
         j=j+1
         jw(na+k)=j
c        is there at least one skipped entry?
         if (j.le.r) then
c           position of the leading skipped entry in column k
            m=jw(1)
c           concatenate linked list for row m
c           add link to column k in front of the list
            l=jw(n5+m)
            jw(n5+m)=k
            jw(n5+k)=l
         elseif (r.lt.jw(nb+k)-1) then 
c           position of the leading skipped entry in column k
            m=jlu(j)
c           concatenate linked list for row m
c           add link to column k in front of the list
            l=jw(n5+m)
            jw(n5+m)=k
            jw(n5+k)=l
         end if 
c        put skipped entries back to the end
         i=0
c        while j<=r
 860     if (j.gt.r) goto 870
            i=i+1
            jlu(j)=jw(i)
            alu(j)=w(i)
            jw(i)=0
            w(i)=0.0d0
            j=j+1
         goto 860
c        end while

c        additional Tismenetsky updates
 870     if (sctype.gt.0) then
c           L-part
            i=0
            j=jw(nb+k)-1
            r=jw(n7+k)-1
            do 881 l=jw(nb+k),r
c              index m of L(m,k)
               m=jlu(l)
c              has this entry been skipped?
c              use jw and w as buff
               if (jw(nc+m).gt.0) then
                  i=i+1
c                 in addition to the shift we have to update the index with
c                 respect to the new permutation
                  jw(i)=jw(n+m)
                  w(i) =alu(l)
               else 
c                 shift entries
                  j=j+1
c                 in addition to the shift we have to update the index with
c                 respect to the new permutation
                  jlu(j)=jw(n+m)
                  alu(j)=alu(l)
               end if
 881        continue
c           first skipped entry in column k of L, epsilon size part
            j=j+1
            jw(n7+k)=j
c           is there at least one node skipped ?
c            if (j.lt.ju(k)) then
            if (j.le.r) then
c              position of the leading skipped node in column k
               m=jw(1)
c              concatenate linked list for row jw(nc+m)
c              add link to column k in front of the list
               l=jw(n9+m)
               jw(n9+m)=k
               jw(n9+k)=l
            elseif (r.lt.ju(k)-1) then
c              position of the leading skipped node in column k
               m=jlu(j)
c              concatenate linked list for row jw(nc+m)
c              add link to column k in front of the list
               l=jw(n9+m)
               jw(n9+m)=k
               jw(n9+k)=l
            end if
c           put skipped entries back to the end
            i=0
 880        if (j.gt.r) goto 890
               i=i+1
               jlu(j)=jw(i)
               alu(j) =w(i)
               jw(i)=0
               w(i)=0.0d0
               j=j+1
            goto 880
c           end while
         end if

       
c        U-part
 890     i=0
         j=ju(k)-1
         r=jw(n2+k)-1
         do 855 l=ju(k),r
c           index m of U(k,m)
            m=jlu(l)
c           has this node been skipped?
c           use jw and w as buff
            if (jw(nc+m).gt.0) then
               i=i+1
c              in addition to the shift we have to update the index
c              with respect to the new permutation
               jw(i)=jw(n+m)
               w(i) =alu(l)
            else 
c              shift entries
               j=j+1
c              in addition to the shift we have to update the index
c              with respect to the new permutation
               jlu(j)=jw(n+m)
               alu(j)=alu(l)
            end if
 855     continue
c        first skipped entry in row k of U, regular part
         j=j+1
         jw(n2+k)=j
c        put skipped entries back to the end
         i=0
c        while j<=r
 865     if (j.gt.r) goto 875
            i=i+1
            jlu(j)=jw(i)
            alu(j)=w(i)
            jw(i)=0
            w(i)=0.0d0
            j=j+1
         goto 865
c        end while

c        additional Tismenetsky updates
 875     if (sctype.gt.0) then
c           U-part
            i=0
            j=jw(nd+k)-1
            r=jw(n8+k)-1
            do 886 l=jw(nd+k),r
c              index m of U(k,m)
               m=jlu(l)
c              is this a coarse grid node?
c              use jw and w as buff
               if (jw(nc+m).gt.0) then
                  i=i+1
c                 in addition to the shift we have to update the index with
c                 respect to the new permutation
                  jw(i)=jw(n+m)
                  w(i) =alu(l)
               else 
c                 shift entries
                  j=j+1
c                 in addition to the shift we have to update the index with
c                 respect to the new permutation
                  jlu(j)=jw(n+m)
                  alu(j)=alu(l)
               end if
 886        continue
c           first skipped entry in row k of U, epsilon size part
            j=j+1
            jw(n8+k)=j
c           put skipped entries back to the end
            i=0
c           while j<=r
 885        if (j.gt.r) goto 895
               i=i+1
               jlu(j)=jw(i)
               alu(j) =w(i)
               jw(i)=0
               w(i)=0.0d0
               j=j+1
            goto 885
c           end while
 895     end if
      end do

c     shuffle skipped entries to the end
      do k=1,n
c        A-part
         i=0
         j=ia(p(k))-1
         r=ia(p(k)+1)-1
         do l=ia(p(k)),r
c           index m of A(p(k),q(m))
            m=invq(ja(l))
c           has this node been skipped?
c           use jw and w as buff
            if (jw(nc+m).gt.0) then
               i=i+1
               jw(i)=ja(l)
               w(i) =a(l)
            else 
c              shift entries
               j=j+1
               ja(j)=ja(l)
               a(j) =a(l)
            end if
         end do
c        first skipped entry in row k of U, regular part
         j=j+1
c        store Afirst
         jw(nu+jw(n+k))=j
c        put skipped entries back to the end
         i=0
c        while j<=r
 896     if (j.gt.r) goto 897
            i=i+1
            ja(j)=jw(i)
            a(j) =w(i)
            jw(i)=0
            w(i)=0.0d0
            j=j+1
         goto 896
c        end while
 897  end do


c     reorder p -> [p(F),p(C)]
      i=0
      j=0
      do 700 k=1,n
         if (jw(nc+k).gt.0) then
            i=i+1
            jw(i)=p(k)
         else
            j=j+1
            p(j)=p(k)
         end if
 700  continue
c     reinsert entries at the end
      i=0
c     while j<n
 710  if (j.ge.n) goto 720
         j=j+1
         i=i+1
         p(j)=jw(i)
         jw(i)=0
      goto 710
c     end while


c     compute permutation q itself
c     use jw(n+1:2n) as buffer
 720  do 730 k=1,n
         jw(n+invq(k))=k
 730  continue
c     reorder q -> [q(F),q(C)]
      i=0
      j=0
      do 705 k=1,n
         if (jw(nc+k).gt.0) then
            i=i+1
            jw(i)=jw(n+k)
         else
            j=j+1
            jw(n+j)=jw(n+k)
         end if
 705  continue
c     reinsert entries at the end
      i=0
c     while j<n
 715  if (j.ge.n) goto 725
         j=j+1
         i=i+1
         jw(n+j)=jw(i)
         jw(i)=0
      goto 715
c     end while

c     correct inverse permutation
 725  do 735 k=1,n
         invq(jw(n+k))=k
 735  continue


c     estimate the norm of any column in S, starting with the diagonal entries
c     and the maximal entry of the original matrix A in this place
      do 737 k=nLU+1,n
         w(n+k)=dabs(alu(k))
 737  continue
      do 738 k=nLU+1,n
c        extract skipped entries of row k from A(p,q)
         j=ia(p(k))
         do 739 l=j,ia(p(k)+1)-1
c           column index i
            i=invq(ja(l))
            w(n2+k)=0.0d0
            if (i.gt.nLU) w(n+i)=max((w(n+i)),dabs(a(l)))
 739     continue
 738  continue


c     compute more accurate approximate Schur complement
      if (simplesc.eq.0.and.sctype.eq.0) then
c        compute L_{CF} L_{FF}^{-1} and U_{FF}^{-1}U_{FC}
c        starting from the last column/row and going back

c        some preparations, norms
c        w(n+i),    i>nLU:  ||A(p(nLU+1:n),q(i))+diagonal part||, already done
c        w(n+k),    k<=nLU: ||A(p(nLU+1:n),q(k))||
c        w(nrow+k), k<=nLU: max_i>nLU |a_ik|/||A(p(i),q(nLU+1:n))+dgl.part||
c        w(nrow+i), i>nLU:  ||A(p(i),q(nLU+1:n))+diagonal part||

         do k=1,nLU
c           used to store ||A(p(nLU+1:n),q(k))||
            w(n+k)=0.0d0
c           used to store max_i>nLU |a_ik|/||A(p(i),q(nLU+1:n))||
            w(nrow+k)=0.0d0
         enddo
         do i=nLU+1,n
c           use w(nrow+i) to compute the row max-norms
            w(nrow+i)=dabs(alu(i))
            m=ia(p(i)+1)
            do j=ia(p(i)),m-1
               k=invq(ja(j))
               if (k.le.nLU) then
                  w(n+k)=max((w(n+k)),dabs(a(j)))
               else
c                 here we have k>nLU
                  w(nrow+i)=max((w(nrow+i)),dabs(a(j)))
               end if
            end do
c           update max_i |a_ik|/||a(i,:)||
c           it suffices to stop before Afirst
            do j=ia(p(i)),jw(nu+i)-1
c              associated column index <= nLU
               k=invq(ja(j))
               ax=dabs(a(j))
               w(nrow+k)=max((w(nrow+k)),ax/(w(nrow+i)))
            end do
         enddo


c        rescale L_CF and U_FC
         do k=1,nLU
c           start at Lfirst
            do l=jw(na+k),jw(nb+k)-1
               alu(l)=alu(l)*alu(k)
            end do
         end do
         do k=1,nLU
c           start at Ufirst
            do l=jw(n2+k),jw(nd+k)-1
               alu(l)=alu(l)*alu(k)
            end do
         end do



c        init L-pointer for the additional columns/rows
         jw(n3+nLU)=jlu(nLU+1)
         do k=nLU-1,1,-1
c           L_CF L_FF^{-1} can be written as a sequence of rank-1 updates
c           starting with the last (but first) column going down to the first
c           in any step k perform linear combination using the associated 
c           columns of L_CF, i.e. compute L_CF L_FF^{-1}(:,k), this can be 
c           rewritten as L_CF (e_k-L_FF^{-1}(:,l+1:nLU) L_FF(l+1:nLU,k))
c           if L_CF L_FF^{-1}(:,k+1:nLU)==L_CF(:,k+1:nLU) + W_CF(:,k+1:nLU),
c           then L_CF L_FF^{-1}(:,k) can be rewritten as
c             L_CF(:,k) - L_CF L_FF^{-1}(:,k+1:nLU) L_FF(k+1:nLU,l)
c            =L_CF(:,k) - [L_CF(:,k+1:nLU) + W_CF(:,k+1:nLU)] L_FF(k+1:nLU,k)
c           =:L_CF(:,k) + W_CF(:,k)
c           => First perform 
c                -sum_{m<=nLU} (L(m,k)/D(k,k)) * L(LU+1:n,m)
c              Then compute
c                -sum_{m<nLU}  (L(m,k)/D(k,k)) * W_CF(LU+1:n,m)
c                (last column is always zero)

c           For the entries of L(l+1:nLU,k) it suffices to stop before Lfirst
            len=0
            do l=jlu(k),jw(na+k)-1
c              associated row index
               m=jlu(l)
c              L(m,k)/D(k,k)
               x=alu(l)*alu(k)

c              First step: 
c                -sum_{m<=nLU} (L(m,k)/D(k,k)) * L(LU+1:n,m)
c              perform linear combinations with column m of L_CF
c              here it suffices to start at Lfirst
               do j=jw(na+m),jw(nb+m)-1
c                 associated row index
                  i=jlu(j)
                  w(i)=w(i)-alu(j)*x
c                 is this a fill-in?
                  if (jw(i).eq.0) then
                     len=len+1
c                    flag component i as nonzero
                     jw(i)=len
c                    add i to the list of nonzeros
                     jw(n+len)=i
                  end if
               end do

c              Second step:
c                -sum_{m<nLU}  (L(m,k)/D(k,k)) * W_CF(LU+1:n,m)
c                (last column is always zero)
               if (m.lt.nLU) then
c                 perform linear combinations with column m of W_CF
                  do j=jw(n3+m+1),jw(n4+m+1)-1
c                    associated row index
                     i=jlu(j)
                     w(i)=w(i)-alu(j)*x
c                    is this a fill-in?
                     if (jw(i).eq.0) then
                        len=len+1
c                       flag component i as nonzero
                        jw(i)=len
c                       add i to the list of nonzeros
                        jw(n+len)=i
                     end if
                  end do
               end if
            end do
         
c           sparsify new column
c           keep in mind that we essentially update 
c           a_p(i),q(j) by a_p(i),q(j)-W_CF(i,k)a(p(k),q(j))
c           compute maximum norm of W_CF(:,k)
            Lmax=0.0d0
            do l=1,len
               i=jw(n+l)
               Lmax=max(Lmax,dabs(w(i)))
            end do
c           compute estimates for the maximum column norm
            DLmax=1.0d0/Lmax
c           also compute Umax=||A(p(k),q(nLU+1:n))||
c           and  DUmax=max{1/Lmax, max_j|a_p(k),q(j)|/||A(p(nLU+1:n),q(j))||}
            Umax=0.0d0
c           it suffices to start at Afirst
            do l=jw(nu+k),ia(p(k)+1)-1
c              associated column index 
               j=invq(ja(l))
c              |A(p(k),q(j))|
               ax=dabs(a(l))
               Umax=max(Umax,ax)
               DLmax=max(DLmax,ax/(w(n+j)))
            end do
c           now finally sparsify W_CF(:,k)
            l=1
            m=len
c           while l<=m
 900        if (l.gt.m) goto 910
c              associated row index
               i=jw(n+l)
c              absolute value of the entry that should be dropped
               ax=dabs(w(i))
c              max-norm ||A(p(i),q(nLU+1:n))||
               axp=(w(nrow+i))

c              three criteria for dropping
c              1. inverse factor L^{-1}, here Workarray is already part
c                 of the inverse, so droptol is correct
c              2. measure the impact of the update 
c                 a_{p(i),q(j)}-W_CF(i,k)*a(p(k),q(j)) for any column j
c              3. measure the impact of the update 
c                 a_{p(i),q(j)}-W_CF(i,k)*a(p(k),q(j)) for row i
               if (ax.le.droptol            .and.
     +             ax*DLmax.le.droptol2     .and.
     +             ax*Umax .le.droptol2*axp)      then
c                 drop entry
                  w(i)=0.0d0
                  jw(i)=0
c                 shuffle final entry in the list to the current position
                  jw(n+l)=jw(n+m)
c                 cut length
                  m=m-1
               else
                  l=l+1
               end if
            goto 900
c           end while
c           new length after dropping
 910        len=m

c           store new column of W_CF behind the previous one of W_FC
            if (jw(n3+k+1)+len.gt.iwk) goto 993
            m=jw(n3+k+1)-1
            do l=1,len
               i=jw(n+l)
               jlu(m+l)=i
               alu(m+l)=w(i)
               jw(i)=0
               w(i)=0.0d0
            end do
            jw(n4+k+1)=jw(n3+k+1)+len


c           now repeat the analogous procedure for the U-part
c
            len=0
c           here it suffices to stop before Ufirst
            do l=ju(k),jw(n2+k)-1
c              associated column index
               m=jlu(l)
               x=alu(l)*alu(k)
c              perform linear combinations with row m of U_FC
c              here it suffices to start at Ufirst
               do j=jw(n2+m),jw(nd+m)-1
c                 associated column index
                  i=jlu(j)
                  w(i)=w(i)-alu(j)*x
c                 is this a fill-in?
                  if (jw(i).eq.0) then
                     len=len+1
c                    flag component i as nonzero
                     jw(i)=len
c                    add i to the list of nonzeros
                     jw(n+len)=i
                  end if
               end do

c              perform linear combinations using using the previously 
c              computed rows of (U_{FF}^{-1}-I)U_{FC} 
               if (m.lt.nLU) then
c                 perform linear combinations with previously computed
c                 rows m 
                  do j=jw(n4+m+1),jw(n3+m)-1
c                    associated column index
                     i=jlu(j)
                     w(i)=w(i)-alu(j)*x
c                    is this a fill-in?
                     if (jw(i).eq.0) then
                        len=len+1
c                       flag component i as nonzero
                        jw(i)=len
c                       add i to the list of nonzeros
                        jw(n+len)=i
                     end if
                  end do
               end if
            end do
         
c           sparsify new row
c           keep in mind that we essentially update 
c           a_p(i),q(j) by a_p(i),q(j)-a(p(i),q(k))*W_FC(k,j)
c           compute maximum norm of W_FC(k,:)
            Umax=0.0d0
            do l=1,len
               i=jw(n+l)
               Umax=max(Umax,dabs(w(i)))
            end do
c           compute estimates for the maximum row norm
            DUmax=max(1.0d0/Umax,(w(nrow+k)))
c           ||A(nLU+1:n,k)||
            Lmax=(w(n+k))
c           now finally sparsify W_FC(:,k)
            l=1
            m=len
c           while l<=m
 920        if (l.gt.m) goto 930
c              associated column index
               i=jw(n+l)
c              absolute value of the entry that should be dropped
               ax=dabs(w(i))
c              norm estimate for column i
               axp=(w(n+i))

c              three criteria for dropping
c              1. inverse factor U^{-1}, here Workarray is already part
c                 of the inverse, so droptol is correct
c              2. measure the impact of the update 
c                 a_{ji}-a(j,k)*Workarray(i,k) for any row j
c              3. measure the impact of the update 
c                 a_{ji}-a(j,k)*Workarray(i,k) for any column i
               if (ax.le.droptol            .and.
     +             ax*DUmax.le.droptol2     .and.
     +             ax*Lmax .le.droptol2*axp)      then
c                 drop entry
                  w(i)=0.0d0
                  jw(i)=0
c                 shuffle final entry in the list to the current position
                  jw(n+l)=jw(n+m)
c                 cut length
                  m=m-1
               else
                  l=l+1
               end if
            goto 920
c           end while
c           new length after dropping
 930        len=m

c           store new row of W_FC behind the previous column of W_CF
            if (jw(n4+k+1)+len.gt.iwk) goto 993
            m=jw(n4+k+1)-1
            do l=1,len
               i=jw(n+l)
               jlu(m+l)=i
               alu(m+l)=w(i)
               jw(i)=0
               w(i)=0.0d0
            end do
            jw(n3+k)=jw(n4+k+1)+len
         end do


c        sort the W_CF buffer in increasing order
c        this is necessary to use the linked list properly
         do k=1,n
            jw(n6+k)=k
         end do
         do k=1,nLU-1
            j=jw(n3+k+1)
            l=jw(n4+k+1)-j
            call qqsort(alu(j),jlu(j),jw(n+1),l,jw(n6+1))
         end do


c        now set up linked list for the additional computed parts
c        jw(nl+k) W_CF,first
c        jw(n6+k) W_CF,list
         do k=1,n
            jw(n6+k)=0
         end do
         do k=1,nLU-1
c           W_CF-part, column k
            j=jw(n3+k+1)
c           first skipped entry in column k of W_CF
            jw(nl+k)=j
c           is there at least one skipped entry?
            if (j.lt.jw(n4+k+1)) then
c              position of the leading skipped entry in column k
               m=jlu(j)
c              concatenate linked list for row m
c              add link to column k in front of the list
               l=jw(n6+m)
               jw(n6+m)=k
               jw(n6+k)=l
            end if 
         end do


c        finally let the approximate Schur complement start behind
c        the nested parts
         jlu(nLU+1)=jw(n3+1)


      end if
c     end more accurate Schur complement

      droptolU=droptols(3)/maxcondest
c     generate approximate Schur complement
      do 740 k=nLU+1,n

c        preparation for the alternative computation of the approximate
c        Schur complement
c        Compute row k of (L_CF+W_CF)*A_FF
         if (simplesc.eq.0 .and. sctype.eq.0) then
            len=0
c           where does row k of W_CF start in the linked list
            i=jw(n6+k)
c           while i>0
 921        if (i.eq.0) goto 929
c              does there exist an entry in W_CF(k,i)?
c              position of the leading entry in column i
               jj=jw(nl+i)
c              nonempty column?
               if (jj.lt.jw(n4+i+1)) then
c                 if this is the case, is the first entry equal to k,
c                 otherwise we don't need to do an update because W_CF(k,i)=0
                  if (jlu(jj).eq.k) then
c                    W_CF(k,i)
                     x=alu(jj)

c                    nonzeros in row i of A_FF
                     jj=ia(p(i))
c                    innermost loop, update, it suffices to stop before Afirst
                     do l=jj,jw(nu+i)-1
c                       column index j of A(p(i),q(j))
                        j=invq(ja(l))
c                       update numerical value
                        w(j)=w(j)+a(l)*x
                        if (jw(j).eq.0) then
                           len=len+1
c                          flag component i as nonzero
                           jw(j)=len
c                          add j to the list of nonzeros
                           jw(n+len)=j
                        end if
                     end do
                  end if 
               end if
c              next column i that has a nonzero in row k
               i=jw(n6+i)
            goto 921
c           end while

c           where does row k of L_CF start in the linked list
 929        i=jw(n5+k)
c           while i>0
 931        if (i.eq.0) goto 939
c              does there exist an entry  L(k,i)?
               jj=jw(na+i)
c              empty column?
               if (jj.lt.jw(nb+i)) then
c                 if this is the case, is the first entry equal to k,
c                 otherwise we don't need to do an update because L(k,i)=0
                  if (jlu(jj).eq.k) then
c                    L(k,i)
                     x=alu(jj)
c                    nonzeros in row i of A

                     jj=ia(p(i))
c                    innermost loop, update, it suffices to stop before Afirst 
                     do l=jj,jw(nu+i)-1
c                       index j of A(i,j)
                        j=invq(ja(l))
c                       update numerical value
                        w(j)=w(j)+a(l)*x
                        if (jw(j).eq.0) then
                           len=len+1
c                          flag component i as nonzero
                           jw(j)=len
c                          add j to the list of nonzeros
                           jw(n+len)=j
                        end if
                     end do
                  end if 
               end if
               i=jw(n5+i)
            goto 931
c           end while

c           transfer entries to w(nrow), jw(ne) and leave them there
 939        m=len
            do i=1,len
               j=jw(n+i)
               jw(ne+i)=j
               w(nrow+i)=w(j)
               w(j)=0.0d0
               jw(j)=0
            end do

         end if
c        end preparation for the more accurate Schur complement

c        extract skipped entries of row k from A(p,q)
         len=0
c        it suffices to start with Afirst
         j=jw(nu+k)
         do 745 l=j,ia(p(k)+1)-1
c           column index i
            i=invq(ja(l))
c            if (i.gt.nLU) then
               len=len+1
c              flag component i as nonzero
               jw(i)=len
c              add i to the list of nonzeros
               jw(n+len)=i
c              extract numerical value
               w(i)=a(l)
c            end if
 745     continue


         if (simplesc.eq.0 .and. sctype.eq.0) then
c           alternative computation of the approximate Schur complement
c           update row k of the Schur complement

c           1. step (-L_CF(.,:)-W_CF(k,:))*A_FC 
c           1.1 -W_CF(k,:)*A_FC
c           linked list, row k of W_CF
            i=jw(n6+k)
c           while i>0
 901        if (i.eq.0) goto 909
c              does there exist an entry in W(k:n,i)?
               jj=jw(nl+i)
c              empty column?
               if (jj.lt.jw(n4+i+1)) then
c                 if this is the case, is the first entry equal to k,
c                 otherwise we don't need to do an update because W(k,i)=0
                  if (jlu(jj).eq.k) then
c                    W(k,i)
                     x=alu(jj)
c                    nonzeros in row i of A, start at position at least k

                     jj=jw(nu+i)
c                    innermost loop, update 
c                    it suffices to start at Afirst
                     do l=jj,ia(p(i)+1)-1
c                       index j of A(p(i),q(j))
                        j=invq(ja(l))
c                       update numerical value
                        w(j)=w(j)-a(l)*x
                        if (jw(j).eq.0) then
                           len=len+1
c                          flag component i as nonzero
                           jw(j)=len
c                          add j to the list of nonzeros
                           jw(n+len)=j
                        end if
                     end do
                  end if 
               end if
               i=jw(n6+i)
            goto 901
c           end while

c           1.2 -L_CF(k,:)*A_FC
c           linked list for the nonzeros in row k of L
 909        i=jw(n5+k)
c           while i>0
 911        if (i.eq.0) goto 919
c              does there exist an entry in L(k:n,i)?
               jj=jw(na+i)
c              empty column?
               if (jj.lt.jw(nb+i)) then
c                 if this is the case, is the first entry equal to k,
c                 otherwise we don't need to do an update because L(k,i)=0
                  if (jlu(jj).eq.k) then
c                    L(k,i)
                     x=alu(jj)
c                    nonzeros in row i of A, start at position at least k

                     jj=jw(nu+i)
c                    innermost loop, update, it suffices to start with Afirst
                     do l=jj,ia(p(i)+1)-1
c                       index j of A(p(i),q(j))
                        j=invq(ja(l))
c                       update numerical value
                        w(j)=w(j)-a(l)*x
                        if (jw(j).eq.0) then
                           len=len+1
c                          flag component i as nonzero
                           jw(j)=len
c                          add j to the list of nonzeros
                           jw(n+len)=j
                        end if
                     end do
                  end if 
               end if
               i=jw(n5+i)
            goto 911
c           end while


c           2. step: A_CF(k,:)*(-W_FC-U_FC)
c           it suffices to stop before Afirst
 919        do i=ia(p(k)),jw(nu+k)-1
c              column index jj of A(p(k),q(jj))
               jj=invq(ja(i))
               x=a(i)

c              2.1 -A_CF(k,:)*U_FC
c              innermost loop, update with U_FC
c              it suffices to start at Ufirst
               do l=jw(n2+jj),jw(nd+jj)-1
c                 index j of U(i,j)
                  j=jlu(l)
c                 update numerical value
                  w(j)=w(j)-alu(l)*x
                  if (jw(j).eq.0) then
                     len=len+1
c                    flag component i as nonzero
                     jw(j)=len
c                    add j to the list of nonzeros
                     jw(n+len)=j
                  end if
               end do

c              2.2 -A_CF(k,:)*W_FC
               if (jj.lt.nLU) then
c                 innermost loop, update with W_FC
                  do l=jw(n4+jj+1),jw(n3+jj)-1
c                    index j of W_FC(jj,j)
                     j=jlu(l)
c                    update numerical value
                     w(j)=w(j)-alu(l)*x
                     if (jw(j).eq.0) then
                        len=len+1
c                       flag component i as nonzero
                        jw(j)=len
c                       add j to the list of nonzeros
                        jw(n+len)=j
                     end if
                  end do
               end if
            end do

c           3.step
c           continue computation of (L_CF(k,:)+W_CF(k,:))*A_FF*(W_FC+U_FC)
c           recall that (L_CF(k,:)+W_FC(k,:)*A_FF is already computed and
c           stored w(nrow+i), jw(ne+i), i=1,...,m
            do i=1,m
               jj=jw(ne+i)
               x=w(nrow+i)

c              3.1 (L_CF(k,:)+W_FC(k,:)*A_FF*U_FC
c              innermost loop, update with U_FC
               do l=jw(n2+jj),jw(nd+jj)-1
c                 index j of U(i,j)
                  j=jlu(l)
c                 update numerical value
                  w(j)=w(j)+alu(l)*x
                  if (jw(j).eq.0) then
                     len=len+1
c                    flag component i as nonzero
                     jw(j)=len
c                    add j to the list of nonzeros
                     jw(n+len)=j
                  end if
               end do

c              3.2 (L_CF(k,:)+W_FC(k,:)*A_FF*W_FC
c              innermost loop, update with W_FC
               if (jj.lt.nLU) then
                  do l=jw(n4+jj+1),jw(n3+jj)-1
c                    index j of W_FC(i,j)
                     j=jlu(l)
c                    update numerical value
                     w(j)=w(j)+alu(l)*x
                     if (jw(j).eq.0) then
                        len=len+1
c                       flag component i as nonzero
                        jw(j)=len
c                       add j to the list of nonzeros
                        jw(n+len)=j
                     end if
                  end do
               end if
            end do

c           end update of the more accurate Schur complement

         else
c           update row k of the Schur complement by subtracting any
c           previous row i=1,...,k-1 depending on the nonzero entries
c           of L(k,1:k-1)
c        
            if (sctype.gt.0) then
c              additional Tismenetsky updates using regular previous rows
c              of U but epsilon size elements of L
c           
c              n         size of the problem
c              k         current step of the update
c              alu       numerical values
c              jlu       associated indices
c              ju        pointers to the first space behind any column of L
c                        (behind the epsilon size entries)
c              jw(nd+1)  pointers to the first space behind any row of U
c                        (behind the regular entries)
c              jw(n9+1)  Llist for the epsilon size part of L
c              jw(n7+1)  Lfirst for the epsilon size part of L
c              jw(n2+1)  Ufirst for the regular part of U
c              jw        indices of nonzero entries and associated list
c              len       length of this list
c              w         numerical values
               call silucupdate(n,k,alu,jlu,ju,jw(nd+1),jw(n9+1),
     +                          jw(n7+1),jw(n2+1),jw,len,w)

c              additional Tismenetsky updates using epsilon size previous
c              rows of U but regular elements of L
c           
c              n         size of the problem
c              k         current step of the update
c              alu       numerical values
c              jlu       associated indices
c              jw(nb+1)  pointers to the first space behind any column of L
c                        (behind the regular entries)
c              jlu(2)    pointers to the first space behind any row of U
c                        (behind the epsilon size entries)
c              jw(n5+1)  Llist for the regular part of L
c              jw(na+1)  Lfirst for the regular part of L
c              jw(n8+1 ) Ufirst for the epsilon size part of U
c              jw        indices of nonzero entries and associated list
c              len       length of this list
c              w         numerical values
               call silucupdate(n,k,alu,jlu,jw(nb+1),jlu(2),jw(n5+1),
     +                          jw(na+1),jw(n8+1),jw,len,w)
            end if
         
c           regular update 
c           n         size of the problem
c           k         current step of the update
c           alu       numerical values
c           jlu       associated indices
c           jw(nb+1)  pointers to the first space behind any column of L
c                     (behind the regular entries)
c           jw(nd+1)  pointers to the first space behind any row of U
c                     (behind the regular size entries)
c           jw(n5+1)  Llist for the regular part of L
c           jw(na+1)  Lfirst for the regular part of L
c           jw(n2+1)  Ufirst for the regular part of U
c           jw        indices of nonzero entries and associated list
c           len       length of this list
c           w         numerical values
            call silucupdate(n,k,alu,jlu,jw(nb+1),jw(nd+1),jw(n5+1),
     +                       jw(na+1),jw(n2+1),jw,len,w)
         end if
c        end computation of row k of the Schur complement

c        is the diagonal entry structurally zero?
         if (jw(k).eq.0) then
            len=len+1
c           flag component i as nonzero
            jw(k)=len
c           add k to the list of nonzeros
            jw(n+len)=k
c           reset numerical value
            w(k)=0.0d0
         end if
c        transfer diagonal entry back including diagonal compensation 
         if (simplesc.ne.0 .or. sctype.ne.0) w(k)=alu(k)

c        --- update approximate Schur complement ---
c        position where the next row of S starts
         jlu(k+1)=jlu(k)+len
         if (jlu(k+1)-1.gt.iwk) goto 990
 989     j=1
         axp=0.0d0
         do 750 i=jlu(k),jlu(k+1)-1
c           extract column index l from the list of nonzeros
            l=jw(n+j)
c           shift column index by nLU to ensure that the indices lie
c           between 1 and n-nLU
            jlu(i)=l-nLU
c           extract numerical value
            alu(i)=w(l)
            axp=max(axp,dabs(w(l)))
c           auxiliary space w(l)
            w(l)=0.0d0
c           clear flag
            jw(l)=0
            j=j+1
 750     continue
c        Sparsify the approximate Schur complement
         j=jlu(k)-1
         axp=axp*droptolU
         xm=0.0d0
         l=jlu(k)
c        length of the original row A(p(k),:) is  ia(p(k)+1)-ia(p(k))
         do 751 i=jlu(k),jlu(k+1)-1
            m=jlu(i)
            x=alu(i)
            w(n+m+nLU)=max((w(n+m+nLU)),dabs(x))
            if (m.eq.k-nLU .or.
     +          dabs(x).gt.min(axp,droptolU*(w(n+m+nLU)))) then
               j=j+1
c              shift and reinsert values
               jlu(j)=m
               alu(j)=x
               w(n2+m+nLU)=max((w(n2+m+nLU)),dabs(x))
c              store the location of the diagonal entry
               if (m.eq.k-nLU) l=j
            else
               xm=xm+alu(i)
            end if
 751     continue
c        zero row encountered, set diagonal entry to 1
         if (axp.eq.0.0d0 .and. droptolU.ne.0.0d0) then 
            alu(l)=1.0d0
         end if

c        modified ILU, diagonal compensation
         if (milu.gt.0) alu(l)=alu(l)+xm
c        new start of row k+1 
         jlu(k+1)=j+1


c        truncate row k such that we will have at most lfils entries
         i=jlu(k)
c        true current length
         j=jlu(k+1)-i
c        maximum length
         m=min0(j,lfils)
c        select the `m' largest entries in modulus
         call qsplit(alu(i),jlu(i),j,m)
c        now m leading entries are left
c        if the diagonal entry is not part of it, include it!
c        also add diagonal compensation
         xm=0.0d0
c        find out whether the diagonal entry has been truncated or not
         l=0
         do i=jlu(k)+m,jlu(k+1)-1
c           store the location of the diagonal entry
            if (jlu(i).eq.k-nLU) then
               l=i
            else
               xm=xm+alu(i)
            end if
         end do
c        include diagonal entry
         if (l.gt.0) then
c           position of the first entry that has been truncated
            i=jlu(k)+m
c           overwrite entry by the values of the diagonal entry
            alu(i)=alu(l)
            jlu(i)=jlu(l)
c           increase number of entries
            m=m+1
         else
            l=jlu(k)
c           if we have to do diagonal compensation
            if (xm.ne.0.0d0 .and. milu.gt.0) then
c              find out where the diagonal entry is stored now
               do i=jlu(k)+1,jlu(k)+m-1
c                 store the location of the diagonal entry
                  if (jlu(i).eq.k-nLU) then
                     l=i
                  end if
               end do
            end if
         end if
c        modified ILU, diagonal compensation
         if (milu.gt.0) alu(l)=alu(l)+xm

c        new start of row k+1 
         jlu(k+1)=jlu(k)+m


c        Update Lfirst, Llist 
c
c        n         size of the problem
c        k         current step of the update procedure
c        jlu       index array
c        jw(nb+1)  pointers to the first space behind any column of L
c                  (points behind the space of the regular part)
c        jw(n5+1)  linked list for the nonzeros of L in row k
c                  (regular part)
c        jw(na+1)  first nonzero entry in L(k:n,i)
c                  (regular part)
         call piluclist(n,k,jlu,jw(nb+1),jw(n5+1),jw(na+1))

c        Tismenetsky update
         if (sctype.gt.0) then

c           n         size of the problem
c           k         current step of the update procedure
c           jlu       index array
c           ju        pointers to the first space behind any column of L
c                     (points behind the space of the epsilon part)
c           jw(n9+1)  linked list for the nonzeros of L in row k
c                     (epsilon size part)
c           jw(n7+1)  first nonzero entry in L(k:n,i)
c                     (epsilon size part)
            call piluclist(n,k,jlu,ju,jw(n9+1),jw(n7+1))
         end if

c        alternative approximate Schur complement, update Wfirst, Wlist
         if (simplesc.eq.0 .and. sctype.eq.0) then
c           n         size of the problem
c           k         current step of the update procedure
c           jlu       index array
c           jw(n4+2)  pointers to the first space behind any column of W_CF
c                     (points to the start of W_FC, array shifted by one)
c           jw(n6+1)  linked list for the nonzeros of W in row k
c           jw(nl+1)  first nonzero entry in W(k:n,i)
            call piluclist(n,k,jlu,jw(n4+2),jw(n6+1),jw(nl+1))
         end if

c        skip garbage collection
         goto 740

c        out of memory, try to get more free space using garbage collection
c        truncate those parts of L,U that are not needed anymore
 990     len=0
         do l=1,nLU
c           check if the coarse part of L can be chopped away

c           L-part
c           shift the leading part by len
            j=jlu(l)
c           associated row index
            m=jlu(j)
c           while m<=nLU & j<Lfirst(l)
 906        if (m.gt.nLU .or. j.ge.jw(na+l)) goto 907
c              shift values
               jlu(j-len)=jlu(j)
               alu(j-len)=alu(j)
               j=j+1
c              associated row index
               m=jlu(j)
            goto 906
c           end while

c           adjust the associated pointer(s)
c           new start of column l
 907        jlu(l)=jlu(l)-len
        
            if (tailor.gt.0) then
c              skip the remaining entries before Lfirst
               len=len+jw(na+l)-j
               jj=jw(na+l)
            else
c              keep the remaining entries
               jj=j
            end if

c           shift the entries that are still needed
            do j=jj,jw(nb+l)-1
c              shift values
               jlu(j-len)=jlu(j)
               alu(j-len)=alu(j)
            end do
c           adjust the associated pointer(s)
c           new Lfirst
            jw(na+l)=jw(na+l)-len

c           Tismenetsky updates
            if (sctype.gt.0) then
c              skip the entries before Lfirst, epsilon
c              number of entries to skip
               jj=jw(n7+l)-jw(nb+l)
c              new start column l, epsilon size part
               jw(nb+l)=jw(nb+l)-len
               len=len+jj
c              shift the remaining entries that are still needed
               do j=jw(n7+l),ju(l)-1
c                 shift values
                  jlu(j-len)=jlu(j)
                  alu(j-len)=alu(j)
               end do
c              adjust the associated pointer(s)
c              new Lfirst, epsilon
               jw(n7+l)=jw(n7+l)-len
            else
c              new pointer to the space behind column l
               jw(nb+l)=jw(nb+l)-len
            end if

c           U-part
c           shift the whole row
            do j=ju(l),jw(nd+l)-1
c              shift values
               jlu(j-len)=jlu(j)
               alu(j-len)=alu(j)
            end do
c           adjust the associated pointer(s)
c           new start of row l
            ju(l)=ju(l)-len
c           new Ufirst
            jw(n2+l)=jw(n2+l)-len

c           Tismenetsky updates
            if (sctype.gt.0) then
c              shift the remaining part, starting at Ufirst, epsilon
               jj=jw(n8+l)-jw(nd+l)
c              adjust the associated pointer(s)
               jw(nd+l)=jw(nd+l)-len
               len=len+jj
               do j=jw(n8+l),jlu(l+1)-1
c                 shift values
                  jlu(j-len)=jlu(j)
                  alu(j-len)=alu(j)
               end do
c              adjust the associated pointer(s)
               jw(n8+l)=jw(n8+l)-len
            else
c              adjust the associated pointer(s)
               jw(nd+l)=jw(nd+l)-len
            end if 
         end do
c        end shift L,U


c        shift workspaces W_CF and W_FC
         if (simplesc.eq.0 .and. sctype.eq.0) then
            do l=nLU-1,1,-1
c              skip the remaining entries before Wfirst
               jj=jw(nl+l)-jw(n3+l+1)
               jw(n3+l+1)=jw(n3+l+1)-len
               len=len+jj

c              shift the entries that are still needed
               do j=jw(nl+l),jw(n4+l+1)-1
c                 shift values
                  jlu(j-len)=jlu(j)
                  alu(j-len)=alu(j)
               end do
c              adjust the associated pointer(s)
c              new Wfirst
               jw(nl+l)=jw(nl+l)-len

c              W_FC-part
c              shift all entries
               do j=jw(n4+l+1),jw(n3+l)-1
c                 shift values
                  jlu(j-len)=jlu(j)
                  alu(j-len)=alu(j)
               end do
c              adjust the associated pointer(s)
               jw(n4+l+1)=jw(n4+l+1)-len
            end do
c           shift final reference
            jw(n3+1)=jw(n3+1)-len
         end if
c        end shift W_CF, W_FC

c        shift approximate Schur-complement
         do l=nLU+1,k-1
            do m=jlu(l),jlu(l+1)
               alu(m-len)=alu(m)
               jlu(m-len)=jlu(m)
            end do
c           adjust pointer
            jlu(l)=jlu(l)-len
         end do
c        adjust final pointer
         jlu(k)=jlu(k)-len
c        adjust new pointer
         jlu(k+1)=jlu(k+1)-len

c        did we successfully reduce the memory?
         if (jlu(k+1)-1.gt.iwk) then
c           no! out of memory
            goto 993
         else
c           yes! resume 
            goto 989
         end if
c        garbage collection completed

 740  continue


c     check for zero columns
      do 741 k=nLU+1,n
c        zero column encountered
         if (w(n2+k).eq.0.0d0) then
c           set diagonal entry to 1
            i=jlu(k)
c           while i<jlu(k+1) and i~=k
 742        if (i.ge.jlu(k+1) .or. jlu(i).eq.k-nLU) goto 743
               i=i+1
            goto 742
c           end while
c           diagonal entry found, fix it!
 743        if (i.lt.jlu(k+1).and.jlu(i).eq.k-nLU) 
     +         alu(i)=1.0d0
         end if
 741  continue


c     advance pointers to the space behind the regular part by the
c     number of skipped entries that are located in front of them
      if (tailor.gt.0) then
         do 605 k=1,nLU
c           L-part
            j=jw(nb+k)-1
            l=jlu(j)
c           while l>nLU & j>=jlu(k)
 606        if (l.le.nLU .or. j.lt.jlu(k)) goto 607
               j=j-1
               l=jlu(j)
            goto 606
 607        jw(nb+k)=j+1

c           U-part
            j=jw(nd+k)-1
            l=jlu(j)
c           while l>nLU & j>=jlu(k)
 608        if (l.le.nLU .or. j.lt.ju(k)) goto 609
               j=j-1
               l=jlu(j)
            goto 608
 609        jw(nd+k)=j+1
 605     continue
      end if

c     remove the embedded small and skipped entries
      len=0
      do 600 k=1,nLU-1
c        gap behind column k of L
         len=len+ju(k)-jw(nb+k)
c        shift U part
         do 610 j=ju(k),jw(nd+k)-1
            alu(j-len)=alu(j)
            jlu(j-len)=jlu(j)
 610     continue
         ju(k)=ju(k)-len
c        gap behind column k of U
         len=len+jlu(k+1)-jw(nd+k)
c        shift L part
         do 620 j=jlu(k+1),jw(nb+k+1)-1
            alu(j-len)=alu(j)
            jlu(j-len)=jlu(j)
 620     continue
         jlu(k+1)=jlu(k+1)-len
 600  continue
c     final column/row
      k=nLU
c     gap behind column k of L
      len=len+ju(k)-jw(nb+k)
c     shift U part
      do 611 j=ju(k),jw(nd+k)-1
         alu(j-len)=alu(j)
         jlu(j-len)=jlu(j)
 611  continue
      ju(k)=ju(k)-len
c     gap behind column k of U
c     this also include W_CF and W_FC
      len=len+jlu(k+1)-jw(nd+k)

c     also shift the approximate Schur complement
      do 602 j=jlu(nLU+1),jlu(n+1)-1
         alu(j-len)=alu(j)
         jlu(j-len)=jlu(j)
 602  continue
      do 601 k=nLU+1,n+1
         jlu(k)=jlu(k)-len
 601  continue


      ierr = 0
      return
c     END regular routine


c     -----   ERROR handling   -----
c


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
c
c     zero row encountered
c     
 995  ierr = -5
      return
c----------------end-of-piluc-------------------------------------------
c-----------------------------------------------------------------------
      end

