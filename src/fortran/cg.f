 subroutine cg(n, rhs, sol, ipar, fpar, w)
      implicit none
      integer n, ipar(16)
      real*8 rhs(*), sol(*), fpar(16), w(n,*)
c-----------------------------------------------------------------------
c     This is a implementation of the Conjugate Gradient (CG) method
c     for solving linear system.
c
c     NOTE: This is not the PCG algorithm. It is a regular CG algorithm.
c     To be consistent with the other solvers, the preconditioners are
c     applied by performing Ml^{-1} A Mr^{-1} P in place of A P in the
c     CG algorithm.  PCG uses the preconditioner differently.
c
c     fpar(7) is used here internally to store <r, r>.
c     w(:,1) -- residual vector
c     w(:,2) -- P, the conjugate direction
c     w(:,3) -- A P, matrix multiply the conjugate direction
c     w(:,4) -- temporary storage for results of preconditioning
c     w(:,5) -- change in the solution (sol) is stored here until
c               termination of this solver
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
      real*8 alpha
      logical lp,rp
      save
c
c     check the status of the call
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (10, 20, 40, 50, 60, 70, 80), ipar(10)
c
c     initialization
c
      call bisinit(ipar,fpar,5*n,1,lp,rp,w)
      if (ipar(1).lt.0) return
c
c     request for matrix vector multiplication A*x in the initialization
c
      ipar(1) = 1
      ipar(8) = n+1
      ipar(9) = ipar(8) + n
      ipar(10) = 1
      do i = 1, n
         w(i,2) = sol(i)
      enddo
      return
 10   ipar(7) = ipar(7) + 1
      ipar(13) = 1
      do i = 1, n
         w(i,2) = rhs(i) - w(i,3)
      enddo
      fpar(11) = fpar(11) + n
c
c     if left preconditioned
c
      if (lp) then
         ipar(1) = 3
         ipar(9) = 1
         ipar(10) = 2
         return
      endif
c
 20   if (lp) then
         do i = 1, n
            w(i,2) = w(i,1)
         enddo
      else
         do i = 1, n
            w(i,1) = w(i,2)
         enddo
      endif
c
      fpar(7) = distdot(n,w,1,w,1)
      fpar(11) = fpar(11) + 2 * n
      fpar(3) = sqrt(fpar(7))
      fpar(5) = fpar(3)
      if (abs(ipar(3)).eq.2) then
         fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
         fpar(11) = fpar(11) + 2 * n
      else if (ipar(3).ne.999) then
         fpar(4) = fpar(1) * fpar(3) + fpar(2)
      endif
c
c     before iteration can continue, we need to compute A * p, which
c     includes the preconditioning operations
c
 30   if (rp) then
         ipar(1) = 5
         ipar(8) = n + 1
         if (lp) then
            ipar(9) = ipar(8) + n
         else
            ipar(9) = 3*n + 1
         endif
         ipar(10) = 3
         return
      endif
c
 40   ipar(1) = 1
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
      ipar(10) = 4
      return
c
 50   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = n+n+1
         ipar(10) = 5
         return
      endif
c
c     continuing with the iterations
c
 60   ipar(7) = ipar(7) + 1
      alpha = distdot(n,w(1,2),1,w(1,3),1)
      fpar(11) = fpar(11) + 2*n
      if (brkdn(alpha,ipar)) goto 900
      alpha = fpar(7) / alpha
      do i = 1, n
         w(i,5) = w(i,5) + alpha * w(i,2)
         w(i,1) = w(i,1) - alpha * w(i,3)
      enddo
      fpar(11) = fpar(11) + 4*n
c
c     are we ready to terminate ?
c
      if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = 4*n + 1
         ipar(9) = 3*n + 1
         ipar(10) = 6
         return
      endif
 70   if (ipar(3).eq.999) then
         if (ipar(11).eq.1) goto 900
      else if (stopbis(n,ipar,1,fpar,w,w(1,2),alpha)) then
         goto 900
      endif
c
c     continue the iterations
c
      alpha = fpar(5)*fpar(5) / fpar(7)
      fpar(7) = fpar(5)*fpar(5)
      do i = 1, n
         w(i,2) = w(i,1) + alpha * w(i,2)
      enddo
      fpar(11) = fpar(11) + 2*n
      goto 30
c
c     clean up -- necessary to accommodate the right-preconditioning
c
 900  if (rp) then
         if (ipar(1).lt.0) ipar(12) = ipar(1)
         ipar(1) = 5
         ipar(8) = 4*n + 1
         ipar(9) = ipar(8) - n
         ipar(10) = 7
         return
      endif
 80   if (rp) then
         call tidycg(n,ipar,fpar,sol,w(1,4))
      else
         call tidycg(n,ipar,fpar,sol,w(1,5))
      endif
c
      return
      end
c-----end-of-cg
