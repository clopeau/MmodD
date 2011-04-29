c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
      subroutine iluk(n,a,ja,ia,lfil,alu,jlu,ju,levs,iwk,w,jw,ierr)
      implicit none 
      integer n
      real*8 a(*),alu(*),w(n)
      integer ja(*),ia(n+1),jlu(*),ju(n),levs(*),jw(3*n),lfil,iwk,ierr
c----------------------------------------------------------------------* 
c     SPARSKIT ROUTINE ILUK -- ILU WITH LEVEL OF FILL-IN OF K (ILU(k)) *
c----------------------------------------------------------------------*
c
c on entry:
c========== 
c n       = integer. The row dimension of the matrix A. The matrix 
c
c a,ja,ia = matrix stored in Compressed Sparse Row format.              
c
c lfil    = integer. The fill-in parameter. Each element whose
c           leve-of-fill exceeds lfil during the ILU process is dropped.
c           lfil must be .ge. 0 
c
c tol     = real*8. Sets the threshold for dropping small terms in the
c           factorization. See below for details on dropping strategy.
c  
c iwk     = integer. The minimum length of arrays alu, jlu, and levs.
c
c On return:
c===========
c
c alu,jlu = matrix stored in Modified Sparse Row (MSR) format containing
c           the L and U factors together. The diagonal (stored in
c           alu(1:n) ) is inverted. Each i-th row of the alu,jlu matrix
c           contains the i-th row of L (excluding the diagonal entry=1)
c           followed by the i-th row of U.
c
c ju      = integer array of length n containing the pointers to
c           the beginning of each row of U in the matrix alu,jlu.
c
c levs    = integer (work) array of size iwk -- which contains the 
c           levels of each element in alu, jlu.
c
c ierr    = integer. Error message with the following meaning.
c           ierr  = 0    --> successful return.
c           ierr .gt. 0  --> zero pivot encountered at step number ierr.
c           ierr  = -1   --> Error. input matrix may be wrong.
c                            (The elimination process has generated a
c                            row in L or U whose length is .gt.  n.)
c           ierr  = -2   --> The matrix L overflows the array al.
c           ierr  = -3   --> The matrix U overflows the array alu.
c           ierr  = -4   --> Illegal value for lfil.
c           ierr  = -5   --> zero row encountered in A or U.
c
c work arrays:
c=============
c jw      = integer work array of length 3*n.
c w       = real work array of length n 
c
c Notes/known bugs: This is not implemented efficiently storage-wise.
c       For example: Only the part of the array levs(*) associated with
c       the U-matrix is needed in the routine.. So some storage can 
c       be saved if needed. The levels of fills in the LU matrix are
c       output for information only -- they are not needed by LU-solve. 
c        
c----------------------------------------------------------------------
c w, ju (1:n) store the working array [1:ii-1 = L-part, ii:n = u] 
c jw(n+1:2n)  stores the nonzero indicator. 
c 
c Notes:
c ------
c All the diagonal elements of the input matrix must be  nonzero.
c
c----------------------------------------------------------------------* 
c     locals
      integer ju0,k,j1,j2,j,ii,i,lenl,lenu,jj,jrow,jpos,n2,
     *     jlev, min 
      real*8 t, s, fact 
      if (lfil .lt. 0) goto 998
c-----------------------------------------------------------------------
c     initialize ju0 (points to next element to be added to alu,jlu)
c     and pointer array.
c-----------------------------------------------------------------------
      n2 = n+n 
      ju0 = n+2
      jlu(1) = ju0
c
c     initialize nonzero indicator array + levs array -- 
c
      do 1 j=1,2*n 
         jw(j)  = 0
 1    continue
c-----------------------------------------------------------------------
c     beginning of main loop.
c-----------------------------------------------------------------------
      do 500 ii = 1, n
         j1 = ia(ii)
         j2 = ia(ii+1) - 1
c     
c     unpack L-part and U-part of row of A in arrays w 
c     
         lenu = 1
         lenl = 0
         jw(ii) = ii
         w(ii) = 0.0
         jw(n+ii) = ii
c
         do 170  j = j1, j2
            k = ja(j)
            t = a(j)
            if (t .eq. 0.0) goto 170 
            if (k .lt. ii) then
               lenl = lenl+1
               jw(lenl) = k
               w(lenl) = t
               jw(n2+lenl) = 0 
               jw(n+k) = lenl
            else if (k .eq. ii) then
               w(ii) = t
               jw(n2+ii) = 0 
            else
               lenu = lenu+1
               jpos = ii+lenu-1 
               jw(jpos) = k
               w(jpos) = t
               jw(n2+jpos) = 0 
               jw(n+k) = jpos
            endif
 170     continue
c
         jj = 0
c
c     eliminate previous rows
c     
 150     jj = jj+1
         if (jj .gt. lenl) goto 160
c-----------------------------------------------------------------------
c     in order to do the elimination in the correct order we must select
c     the smallest column index among jw(k), k=jj+1, ..., lenl.
c-----------------------------------------------------------------------
         jrow = jw(jj)
         k = jj
c     
c     determine smallest column index
c     
         do 151 j=jj+1,lenl
            if (jw(j) .lt. jrow) then
               jrow = jw(j)
               k = j
            endif
 151     continue
c
         if (k .ne. jj) then
c     exchange in jw
            j = jw(jj)
            jw(jj) = jw(k)
            jw(k) = j
c     exchange in jw(n+  (pointers/ nonzero indicator).
            jw(n+jrow) = jj
            jw(n+j) = k
c     exchange in jw(n2+  (levels) 
            j = jw(n2+jj) 
            jw(n2+jj)  = jw(n2+k) 
            jw(n2+k) = j
c     exchange in w
            s = w(jj)
            w(jj) = w(k)
            w(k) = s
         endif
c
c     zero out element in row by resetting jw(n+jrow) to zero.
c     
         jw(n+jrow) = 0
c     
c     get the multiplier for row to be eliminated (jrow) + its level
c     
         fact = w(jj)*alu(jrow)
         jlev = jw(n2+jj) 
         if (jlev .gt. lfil) goto 150
c
c     combine current row and row jrow
c
         do 203 k = ju(jrow), jlu(jrow+1)-1
            s = fact*alu(k)
            j = jlu(k)
            jpos = jw(n+j)
            if (j .ge. ii) then
c     
c     dealing with upper part.
c     
               if (jpos .eq. 0) then
c
c     this is a fill-in element
c     
                  lenu = lenu+1
                  if (lenu .gt. n) goto 995
                  i = ii+lenu-1
                  jw(i) = j
                  jw(n+j) = i
                  w(i) = - s
                  jw(n2+i) = jlev+levs(k)+1 
               else
c
c     this is not a fill-in element 
c
                  w(jpos) = w(jpos) - s
                  jw(n2+jpos) = min(jw(n2+jpos),jlev+levs(k)+1)
               endif
            else
c     
c     dealing with lower part.
c     
               if (jpos .eq. 0) then
c
c     this is a fill-in element
c
                  lenl = lenl+1
                  if (lenl .gt. n) goto 995
                  jw(lenl) = j
                  jw(n+j) = lenl
                  w(lenl) = - s
                  jw(n2+lenl) = jlev+levs(k)+1 
               else
c
c     this is not a fill-in element 
c
                  w(jpos) = w(jpos) - s
                  jw(n2+jpos) = min(jw(n2+jpos),jlev+levs(k)+1)
               endif
            endif
 203     continue
         w(jj) = fact
         jw(jj)  = jrow
         goto 150 
 160     continue 
c     
c     reset double-pointer to zero (U-part) 
c     
         do 308 k=1, lenu
            jw(n+jw(ii+k-1)) = 0
 308     continue
c
c     update l-matrix
c         
         do 204 k=1, lenl 
            if (ju0 .gt. iwk) goto 996
            if (jw(n2+k) .le. lfil) then
               alu(ju0) =  w(k)
               jlu(ju0) =  jw(k)
               ju0 = ju0+1
            endif
 204     continue
c     
c     save pointer to beginning of row ii of U
c     
         ju(ii) = ju0
c
c     update u-matrix
c
         do 302 k=ii+1,ii+lenu-1 
            if (jw(n2+k) .le. lfil) then
               jlu(ju0) = jw(k)
               alu(ju0) = w(k)
               levs(ju0) = jw(n2+k) 
               ju0 = ju0+1
            endif
 302     continue

         if (w(ii) .eq. 0.0) goto 999 
c     
         alu(ii) = 1.0d0/ w(ii) 
c     
c     update pointer to beginning of next row of U.
c     
         jlu(ii+1) = ju0
c-----------------------------------------------------------------------
c     end main loop
c-----------------------------------------------------------------------
 500  continue
      ierr = 0
      return
c
c     incomprehensible error. Matrix must be wrong.
c     
 995  ierr = -1
      return
c     
c     insufficient storage in L.
c     
 996  ierr = -2
      return
c     
c     insufficient storage in U.
c     
 997  ierr = -3
      return
c     
c     illegal lfil entered.
c     
 998  ierr = -4
      return
c     
c     zero row encountered in A or U. 
c     
 999  ierr = -5
      return
c----------------end-of-iluk--------------------------------------------
c-----------------------------------------------------------------------
      end
