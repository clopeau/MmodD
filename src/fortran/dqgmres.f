c-----------------------------------------------------------------------
      subroutine dqgmres(n, rhs, sol, ipar, fpar, w)
      implicit none
      integer n, ipar(16)
      real*8 rhs(n), sol(n), fpar(16), w(*)
c-----------------------------------------------------------------------
c     DQGMRES -- Flexible Direct version of Quasi-General Minimum
c     Residual method. The right preconditioning can be varied from
c     step to step.
c
c     Work space used = n + lb * (2*n+4)
c     where lb = ipar(5) + 1 (default 16 if ipar(5) <= 1)
c-----------------------------------------------------------------------
c     local variables
c
      real*8 one,zero,deps
      parameter(one=1.0D0,zero=0.0D0)
      parameter(deps=1.0D-33)
c
      integer i,ii,j,jp1,j0,k,ptrw,ptrv,iv,iw,ic,is,ihm,ihd,lb,ptr
      real*8 alpha,beta,psi,c,s,distdot
      logical lp,rp,full
      external distdot,bisinit
      save
c
c     where to go
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (10, 20, 40, 50, 60, 70) ipar(10)
c
c     locations of the work arrays. The arrangement is as follows:
c     w(1:n) -- temporary storage for the results of the preconditioning
c     w(iv+1:iw) -- the V's
c     w(iw+1:ic) -- the W's
c     w(ic+1:is) -- the COSINEs of the Givens rotations
c     w(is+1:ihm) -- the SINEs of the Givens rotations
c     w(ihm+1:ihd) -- the last column of the Hessenberg matrix
c     w(ihd+1:i) -- the inverse of the diagonals of the Hessenberg matrix
c
      if (ipar(5).le.1) then
         lb = 16
      else
         lb = ipar(5) + 1
      endif
      iv = n
      iw = iv + lb * n
      ic = iw + lb * n
      is = ic + lb
      ihm = is + lb
      ihd = ihm + lb
      i = ihd + lb
c
c     parameter check, initializations
c
      full = .false.
      call bisinit(ipar,fpar,i,1,lp,rp,w)
      if (ipar(1).lt.0) return
      ipar(1) = 1
      if (lp) then
         do ii = 1, n
            w(iv+ii) = sol(ii)
         enddo
         ipar(8) = iv+1
         ipar(9) = 1
      else
         do ii = 1, n
            w(ii) = sol(ii)
         enddo
         ipar(8) = 1
         ipar(9) = iv+1
      endif
      ipar(10) = 1
      return
c
 10   ipar(7) = ipar(7) + 1
      ipar(13) = ipar(13) + 1
      if (lp) then
         do i = 1, n
            w(i) = rhs(i) - w(i)
         enddo
         ipar(1) = 3
         ipar(8) = 1
         ipar(9) = iv+1
         ipar(10) = 2
         return
      else
         do i = 1, n
            w(iv+i) = rhs(i) - w(iv+i)
         enddo
      endif
      fpar(11) = fpar(11) + n
c
 20   alpha = sqrt(distdot(n, w(iv+1), 1, w(iv+1), 1))
      fpar(11) = fpar(11) + (n + n)
      if (abs(ipar(3)).eq.2) then
         fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
         fpar(11) = fpar(11) + 2*n
      else if (ipar(3).ne.999) then
         fpar(4) = fpar(1) * alpha + fpar(2)
      endif
      fpar(3) = alpha
      fpar(5) = alpha
      psi = alpha
      if (alpha.le.fpar(4)) then
         ipar(1) = 0
         fpar(6) = alpha
         goto 80
      endif
      alpha = one / alpha
      do i = 1, n
         w(iv+i) = w(iv+i) * alpha
      enddo
      fpar(11) = fpar(11) + n
      j = 0
c
c     iterations start here
c
 30   j = j + 1
      if (j.gt.lb) j = j - lb
      jp1 = j + 1
      if (jp1.gt.lb) jp1 = jp1 - lb
      ptrv = iv + (j-1)*n + 1
      ptrw = iv + (jp1-1)*n + 1
      if (.not.full) then
         if (j.gt.jp1) full = .true.
      endif
      if (full) then
         j0 = jp1+1
         if (j0.gt.lb) j0 = j0 - lb
      else
         j0 = 1
      endif
c
c     request the caller to perform matrix-vector multiplication and
c     preconditioning
c
      if (rp) then
         ipar(1) = 5
         ipar(8) = ptrv
         ipar(9) = ptrv + iw - iv
         ipar(10) = 3
         return
      else
         do i = 0, n-1
            w(ptrv+iw-iv+i) = w(ptrv+i)
         enddo
      endif
c
 40   ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = ptrv
      endif
      if (lp) then
         ipar(9) = 1
      else
         ipar(9) = ptrw
      endif
      ipar(10) = 4
      return
c
 50   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = ptrw
         ipar(10) = 5
         return
      endif
c
c     compute the last column of the Hessenberg matrix
c     modified Gram-schmidt procedure, orthogonalize against (lb-1)
c     previous vectors
c
 60   continue
      call mgsro(full,n,n,lb,jp1,fpar(11),w(iv+1),w(ihm+1),
     $     ipar(12))
      if (ipar(12).lt.0) then
         ipar(1) = -3
         goto 80
      endif
      beta = w(ihm+jp1)
c
c     incomplete factorization (QR factorization through Givens rotations)
c     (1) apply previous rotations [(lb-1) of them]
c     (2) generate a new rotation
c
      if (full) then
         w(ihm+jp1) = w(ihm+j0) * w(is+jp1)
         w(ihm+j0) = w(ihm+j0) * w(ic+jp1)
      endif
      i = j0
      do while (i.ne.j)
         k = i+1
         if (k.gt.lb) k = k - lb
         c = w(ic+i)
         s = w(is+i)
         alpha = w(ihm+i)
         w(ihm+i) = c * alpha + s * w(ihm+k)
         w(ihm+k) = c * w(ihm+k) - s * alpha
         i = k
      enddo
      call givens(w(ihm+j), beta, c, s)
      if (full) then
         fpar(11) = fpar(11) + 6 * lb
      else
         fpar(11) = fpar(11) + 6 * j
      endif
c
c     detect whether diagonal element of this column is zero
c
      if (abs(w(ihm+j)).lt.deps) then
         ipar(1) = -3
         goto 80
      endif
      w(ihd+j) = one / w(ihm+j)
      w(ic+j) = c
      w(is+j) = s
c
c     update the W's (the conjugate directions) -- essentially this is one
c     step of triangular solve.
c
      ptrw = iw+(j-1)*n + 1
      if (full) then
         do i = j+1, lb
            alpha = -w(ihm+i)*w(ihd+i)
            ptr = iw+(i-1)*n+1
            do ii = 0, n-1
               w(ptrw+ii) = w(ptrw+ii) + alpha * w(ptr+ii)
            enddo
         enddo
      endif
      do i = 1, j-1
         alpha = -w(ihm+i)*w(ihd+i)
         ptr = iw+(i-1)*n+1
         do ii = 0, n-1
            w(ptrw+ii) = w(ptrw+ii) + alpha * w(ptr+ii)
         enddo
      enddo
c
c     update the solution to the linear system
c
      alpha = psi * c * w(ihd+j)
      psi = - s * psi
      do i = 1, n
         sol(i) = sol(i) + alpha * w(ptrw-1+i)
      enddo
      if (full) then
         fpar(11) = fpar(11) + lb * (n+n)
      else
         fpar(11) = fpar(11) + j * (n+n)
      endif
c
c     determine whether to continue,
c     compute the desired error/residual norm
c
      ipar(7) = ipar(7) + 1
      fpar(5) = abs(psi)
      if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = -1
         ipar(9) = 1
         ipar(10) = 6
         return
      endif
      if (ipar(3).lt.0) then
         alpha = abs(alpha)
         if (ipar(7).eq.2 .and. ipar(3).eq.-1) then
            fpar(3) = alpha*sqrt(distdot(n, w(ptrw), 1, w(ptrw), 1))
            fpar(4) = fpar(1) * fpar(3) + fpar(2)
            fpar(6) = fpar(3)
         else
            fpar(6) = alpha*sqrt(distdot(n, w(ptrw), 1, w(ptrw), 1))
         endif
         fpar(11) = fpar(11) + 2 * n
      else
         fpar(6) = fpar(5)
      endif
      if (ipar(1).ge.0 .and. fpar(6).gt.fpar(4) .and. (ipar(6).le.0
     +     .or. ipar(7).lt.ipar(6))) goto 30
 70   if (ipar(3).eq.999 .and. ipar(11).eq.0) goto 30
c
c     clean up the iterative solver
c
 80   fpar(7) = zero
      if (fpar(3).ne.zero .and. fpar(6).ne.zero .and.
     +     ipar(7).gt.ipar(13))
     +     fpar(7) = log10(fpar(3) / fpar(6)) / dble(ipar(7)-ipar(13))
      if (ipar(1).gt.0) then
         if (ipar(3).eq.999 .and. ipar(11).ne.0) then
            ipar(1) = 0
         else if (fpar(6).le.fpar(4)) then
            ipar(1) = 0
         else if (ipar(6).gt.0 .and. ipar(7).ge.ipar(6)) then
            ipar(1) = -1
         else
            ipar(1) = -10
         endif
      endif
      return
      end
c-----end-of-dqgmres
