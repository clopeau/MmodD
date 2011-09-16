c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c
      subroutine mgsro(full,lda,n,m,ind,ops,vec,hh,ierr)
      implicit none
      logical full
      integer lda,m,n,ind,ierr
      real*8  ops,hh(m),vec(lda,m)
c-----------------------------------------------------------------------
c     MGSRO  -- Modified Gram-Schmidt procedure with Selective Re-
c               Orthogonalization
c     The ind'th vector of VEC is orthogonalized against the rest of
c     the vectors.
c
c     The test for performing re-orthogonalization is performed for
c     each indivadual vectors. If the cosine between the two vectors
c     is greater than 0.99 (REORTH = 0.99**2), re-orthogonalization is
c     performed. The norm of the 'new' vector is kept in variable NRM0,
c     and updated after operating with each vector.
c
c     full   -- .ture. if it is necessary to orthogonalize the ind'th
c               against all the vectors vec(:,1:ind-1), vec(:,ind+2:m)
c               .false. only orthogonalize againt vec(:,1:ind-1)
c     lda    -- the leading dimension of VEC
c     n      -- length of the vector in VEC
c     m      -- number of vectors can be stored in VEC
c     ind    -- index to the vector to be changed
c     ops    -- operation counts
c     vec    -- vector of LDA X M storing the vectors
c     hh     -- coefficient of the orthogonalization
c     ierr   -- error code
c               0 : successful return
c               -1: zero input vector
c               -2: input vector contains abnormal numbers
c               -3: input vector is a linear combination of others
c
c     External routines used: real*8 distdot
c-----------------------------------------------------------------------
      integer i,k
      real*8  nrm0, nrm1, fct, thr, distdot, zero, one, reorth
      parameter (zero=0.0D0, one=1.0D0, reorth=0.98D0)
      external distdot
c
c     compute the norm of the input vector
c
      nrm0 = distdot(n,vec(1,ind),1,vec(1,ind),1)
      ops = ops + n + n
      thr = nrm0 * reorth
      if (nrm0.le.zero) then
         ierr = - 1
         return
      else if (nrm0.gt.zero .and. one/nrm0.gt.zero) then
         ierr = 0
      else
         ierr = -2
         return
      endif
c
c     Modified Gram-Schmidt loop
c
      if (full) then
         do 40 i = ind+1, m
            fct = distdot(n,vec(1,ind),1,vec(1,i),1)
            hh(i) = fct
            do 20 k = 1, n
               vec(k,ind) = vec(k,ind) - fct * vec(k,i)
 20         continue
            ops = ops + 4 * n + 2
            if (fct*fct.gt.thr) then
               fct = distdot(n,vec(1,ind),1,vec(1,i),1)
               hh(i) = hh(i) + fct
               do 30 k = 1, n
                  vec(k,ind) = vec(k,ind) - fct * vec(k,i)
 30            continue
               ops = ops + 4*n + 1
            endif
            nrm0 = nrm0 - hh(i) * hh(i)
            if (nrm0.lt.zero) nrm0 = zero
            thr = nrm0 * reorth
 40      continue
      endif
c
      do 70 i = 1, ind-1
         fct = distdot(n,vec(1,ind),1,vec(1,i),1)
         hh(i) = fct
         do 50 k = 1, n
            vec(k,ind) = vec(k,ind) - fct * vec(k,i)
 50      continue
         ops = ops + 4 * n + 2
         if (fct*fct.gt.thr) then
            fct = distdot(n,vec(1,ind),1,vec(1,i),1)
            hh(i) = hh(i) + fct
            do 60 k = 1, n
               vec(k,ind) = vec(k,ind) - fct * vec(k,i)
 60         continue
            ops = ops + 4*n + 1
         endif
         nrm0 = nrm0 - hh(i) * hh(i)
         if (nrm0.lt.zero) nrm0 = zero
         thr = nrm0 * reorth
 70   continue
c
c     test the resulting vector
c
      nrm1 = sqrt(distdot(n,vec(1,ind),1,vec(1,ind),1))
      ops = ops + n + n
 75   hh(ind) = nrm1
      if (nrm1.le.zero) then
         ierr = -3
         return
      endif
c
c     scale the resulting vector
c
      fct = one / nrm1
      do 80 k = 1, n
         vec(k,ind) = vec(k,ind) * fct
 80   continue
      ops = ops + n + 1
c
c     normal return
c
      ierr = 0
      return
c     end surbotine mgsro
      end
