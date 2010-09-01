c-----------------------------------------------------------------------
      subroutine cgnr(n,rhs,sol,ipar,fpar,wk)
      implicit none
      integer n, ipar(16)
      real*8 rhs(n),sol(n),fpar(16),wk(n,*)
c-----------------------------------------------------------------------
c     CGNR -- Using CG algorithm solving A x = b by solving
c     Normal Residual equation: A^T A x = A^T b
c     As long as the matrix is not singular, A^T A is symmetric
c     positive definite, therefore CG (CGNR) will converge.
c
c     Usage of the work space:
c     wk(:,1) == residual vector R
c     wk(:,2) == the conjugate direction vector P
c     wk(:,3) == a scratch vector holds A P, or A^T R
c     wk(:,4) == a scratch vector holds intermediate results of the
c                preconditioning
c     wk(:,5) == a place to hold the modification to SOL
c
c     size of the work space WK is required = 5*n
c-----------------------------------------------------------------------
c     external functions used
c
      real*8 distdot
      logical stopbis, brkdn
      external distdot, stopbis, brkdn, bisinit
c
c     local variables
c
      integer i
      real*8 alpha, zz, zzm1
      logical lp, rp
      save
c
c     check the status of the call
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (10, 20, 40, 50, 60, 70, 80, 90, 100, 110), ipar(10)
c
c     initialization
c
      call bisinit(ipar,fpar,5*n,1,lp,rp,wk)
      if (ipar(1).lt.0) return
c
c     request for matrix vector multiplication A*x in the initialization
c
      ipar(1) = 1
      ipar(8) = 1
      ipar(9) = 1 + n
      ipar(10) = 1
      do i = 1, n
         wk(i,1) = sol(i)
      enddo
      return
 10   ipar(7) = ipar(7) + 1
      ipar(13) = ipar(13) + 1
      do i = 1, n
         wk(i,1) = rhs(i) - wk(i,2)
      enddo
      fpar(11) = fpar(11) + n
c
c     if left preconditioned, precondition the initial residual
c
      if (lp) then
         ipar(1) = 3
         ipar(10) = 2
         return
      endif
c
 20   if (lp) then
         do i = 1, n
            wk(i,1) = wk(i,2)
         enddo
      endif
c
      zz = distdot(n,wk,1,wk,1)
      fpar(11) = fpar(11) + 2 * n
      fpar(3) = sqrt(zz)
      fpar(5) = fpar(3)
      if (abs(ipar(3)).eq.2) then
         fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
         fpar(11) = fpar(11) + 2 * n
      else if (ipar(3).ne.999) then
         fpar(4) = fpar(1) * fpar(3) + fpar(2)
      endif
c
c     normal iteration begins here, first half of the iteration
c     computes the conjugate direction
c
 30   continue
c
c     request the caller to perform a A^T r --> wk(:,3)
c
      if (lp) then
         ipar(1) = 4
         ipar(8) = 1
         if (rp) then
            ipar(9) = n + n + 1
         else
            ipar(9) = 3*n + 1
         endif
         ipar(10) = 3
         return
      endif
c
 40   ipar(1) = 2
      if (lp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = 1
      endif
      if (rp) then
         ipar(9) = 3*n + 1
      else
         ipar(9) = n + n + 1
      endif
      ipar(10) = 4
      return
c
 50   if (rp) then
         ipar(1) = 6
         ipar(8) = ipar(9)
         ipar(9) = n + n + 1
         ipar(10) = 5
         return
      endif
c
 60   ipar(7) = ipar(7) + 1
      zzm1 = zz
      zz = distdot(n,wk(1,3),1,wk(1,3),1)
      fpar(11) = fpar(11) + 2 * n
      if (brkdn(zz,ipar)) goto 900
      if (ipar(7).gt.3) then
         alpha = zz / zzm1
         do i = 1, n
            wk(i,2) = wk(i,3) + alpha * wk(i,2)
         enddo
         fpar(11) = fpar(11) + 2 * n
      else
         do i = 1, n
            wk(i,2) = wk(i,3)
         enddo
      endif
c
c     before iteration can continue, we need to compute A * p
c
      if (rp) then
         ipar(1) = 5
         ipar(8) = n + 1
         if (lp) then
            ipar(9) = ipar(8) + n
         else
            ipar(9) = 3*n + 1
         endif
         ipar(10) = 6
         return
      endif
c
 70   ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = n + 1
      endif
      if (lp) then
        ipar(9) = 3*n+1
      else
         ipar(9) = n+n+1
      endif
      ipar(10) = 7
      return
c
 80   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = n+n+1
         ipar(10) = 8
         return
      endif
c
c     update the solution -- accumulate the changes in w(:,5)
c
 90   ipar(7) = ipar(7) + 1
      alpha = distdot(n,wk(1,3),1,wk(1,3),1)
      fpar(11) = fpar(11) + 2 * n
      if (brkdn(alpha,ipar)) goto 900
      alpha = zz / alpha
      do i = 1, n
         wk(i,5) = wk(i,5) + alpha * wk(i,2)
         wk(i,1) = wk(i,1) - alpha * wk(i,3)
      enddo
      fpar(11) = fpar(11) + 4 * n
c
c     are we ready to terminate ?
c
      if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = 4*n + 1
         ipar(9) = 3*n + 1
         ipar(10) = 9
         return
      endif
 100  if (ipar(3).eq.999) then
         if (ipar(11).eq.1) goto 900
      else if (stopbis(n,ipar,1,fpar,wk,wk(1,2),alpha)) then
         goto 900
      endif
c
c     continue the iterations
c
      goto 30
c
c     clean up -- necessary to accommodate the right-preconditioning
c
 900  if (rp) then
         if (ipar(1).lt.0) ipar(12) = ipar(1)
         ipar(1) = 5
         ipar(8) = 4*n + 1
         ipar(9) = ipar(8) - n
         ipar(10) = 10
         return
      endif
 110  if (rp) then
         call tidycg(n,ipar,fpar,sol,wk(1,4))
      else
         call tidycg(n,ipar,fpar,sol,wk(1,5))
      endif
      return
      end
c-----end-of-cgnr
