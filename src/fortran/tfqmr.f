c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c
c-----------------------------------------------------------------------
      subroutine tfqmr(n, rhs, sol, ipar, fpar, w)
      implicit none
      integer n, ipar(16)
      real*8 rhs(n), sol(n), fpar(16), w(n,*)
c-----------------------------------------------------------------------
c     TFQMR --- transpose-free Quasi-Minimum Residual method
c     This is developed from BCG based on the principle of Quasi-Minimum
c     Residual, and it is transpose-free.
c
c     It uses approximate residual norm.
c
c     Internally, the fpar's are used as following:
c     fpar(3) --- initial residual norm squared
c     fpar(4) --- target residual norm squared
c     fpar(5) --- current residual norm squared
c
c     w(:,1) -- R, residual
c     w(:,2) -- R0, the initial residual
c     w(:,3) -- W
c     w(:,4) -- Y
c     w(:,5) -- Z
c     w(:,6) -- A * Y
c     w(:,7) -- A * Z
c     w(:,8) -- V
c     w(:,9) -- D
c     w(:,10) -- intermediate results of preconditioning
c     w(:,11) -- changes in the solution
c-----------------------------------------------------------------------
c     external functions
c
      real*8 distdot
      logical brkdn
      external brkdn, distdot
c
      real*8 one,zero
      parameter(one=1.0D0,zero=0.0D0)
c
c     local variables
c
      integer i
      logical lp, rp
      real*8 eta,sigma,theta,te,alpha,rho,tao
      save
c
c     status of the call (where to go)
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (10,20,40,50,60,70,80,90,100,110), ipar(10)
c
c     initializations
c
      call bisinit(ipar,fpar,11*n,2,lp,rp,w)
      if (ipar(1).lt.0) return
      ipar(1) = 1
      ipar(8) = 1
      ipar(9) = 1 + 6*n
      do i = 1, n
         w(i,1) = sol(i)
      enddo
      ipar(10) = 1
      return
 10   ipar(7) = ipar(7) + 1
      ipar(13) = ipar(13) + 1
      do i = 1, n
         w(i,1) = rhs(i) - w(i,7)
         w(i,9) = zero
      enddo
      fpar(11) = fpar(11) + n
c
      if (lp) then
         ipar(1) = 3
         ipar(9) = n+1
         ipar(10) = 2
         return
      endif
 20   continue
      if (lp) then
         do i = 1, n
            w(i,1) = w(i,2)
            w(i,3) = w(i,2)
         enddo
      else
         do i = 1, n
            w(i,2) = w(i,1)
            w(i,3) = w(i,1)
         enddo
      endif
c
      fpar(5) = sqrt(distdot(n,w,1,w,1))
      fpar(3) = fpar(5)
      tao = fpar(5)
      fpar(11) = fpar(11) + n + n
      if (abs(ipar(3)).eq.2) then
         fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
         fpar(11) = fpar(11) + n + n
      else if (ipar(3).ne.999) then
         fpar(4) = fpar(1) * tao + fpar(2)
      endif
      te = zero
      rho = zero
c
c     begin iteration
c
 30   sigma = rho
      rho = distdot(n,w(1,2),1,w(1,3),1)
      fpar(11) = fpar(11) + n + n
      if (brkdn(rho,ipar)) goto 900
      if (ipar(7).eq.1) then
         alpha = zero
      else
         alpha = rho / sigma
      endif
      do i = 1, n
         w(i,4) = w(i,3) + alpha * w(i,5)
      enddo
      fpar(11) = fpar(11) + n + n
c
c     A * x -- with preconditioning
c
      if (rp) then
         ipar(1) = 5
         ipar(8) = 3*n + 1
         if (lp) then
            ipar(9) = 5*n + 1
         else
            ipar(9) = 9*n + 1
         endif
         ipar(10) = 3
         return
      endif
c
 40   ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = 3*n + 1
      endif
      if (lp) then
         ipar(9) = 9*n + 1
      else
         ipar(9) = 5*n + 1
      endif
      ipar(10) = 4
      return
c
 50   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = 5*n + 1
         ipar(10) = 5
         return
      endif
 60   ipar(7) = ipar(7) + 1
      do i = 1, n
         w(i,8) = w(i,6) + alpha * (w(i,7) + alpha * w(i,8))
      enddo
      sigma = distdot(n,w(1,2),1,w(1,8),1)
      fpar(11) = fpar(11) + 6 * n
      if (brkdn(sigma,ipar)) goto 900
      alpha = rho / sigma
      do i = 1, n
         w(i,5) = w(i,4) - alpha * w(i,8)
      enddo
      fpar(11) = fpar(11) + 2*n
c
c     the second A * x
c
      if (rp) then
         ipar(1) = 5
         ipar(8) = 4*n + 1
         if (lp) then
            ipar(9) = 6*n + 1
         else
            ipar(9) = 9*n + 1
         endif
         ipar(10) = 6
         return
      endif
c
 70   ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = 4*n + 1
      endif
      if (lp) then
         ipar(9) = 9*n + 1
      else
         ipar(9) = 6*n + 1
      endif
      ipar(10) = 7
      return
c
 80   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = 6*n + 1
         ipar(10) = 8
         return
      endif
 90   ipar(7) = ipar(7) + 1
      do i = 1, n
         w(i,3) = w(i,3) - alpha * w(i,6)
      enddo
c
c     update I
c
      theta = distdot(n,w(1,3),1,w(1,3),1) / (tao*tao)
      sigma = one / (one + theta)
      tao = tao * sqrt(sigma * theta)
      fpar(11) = fpar(11) + 4*n + 6
      if (brkdn(tao,ipar)) goto 900
      eta = sigma * alpha
      sigma = te / alpha
      te = theta * eta
      do i = 1, n
         w(i,9) = w(i,4) + sigma * w(i,9)
         w(i,11) = w(i,11) + eta * w(i,9)
         w(i,3) = w(i,3) - alpha * w(i,7)
      enddo
      fpar(11) = fpar(11) + 6 * n + 6
      if (ipar(7).eq.1) then
         if (ipar(3).eq.-1) then
            fpar(3) = eta * sqrt(distdot(n,w(1,9),1,w(1,9),1))
            fpar(4) = fpar(1)*fpar(3) + fpar(2)
            fpar(11) = fpar(11) + n + n + 4
         endif
      endif
c
c     update II
c
      theta = distdot(n,w(1,3),1,w(1,3),1) / (tao*tao)
      sigma = one / (one + theta)
      tao = tao * sqrt(sigma * theta)
      fpar(11) = fpar(11) + 8 + 2*n
      if (brkdn(tao,ipar)) goto 900
      eta = sigma * alpha
      sigma = te / alpha
      te = theta * eta
      do i = 1, n
         w(i,9) = w(i,5) + sigma * w(i,9)
         w(i,11) = w(i,11) + eta * w(i,9)
      enddo
      fpar(11) = fpar(11) + 4*n + 3
c
c     this is the correct over-estimate
c      fpar(5) = sqrt(real(ipar(7)+1)) * tao
c     this is an approximation
      fpar(5) = tao
      if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = 10*n + 1
         ipar(9) = 9*n + 1
         ipar(10) = 9
         return
      else if (ipar(3).lt.0) then
         fpar(6) = eta * sqrt(distdot(n,w(1,9),1,w(1,9),1))
         fpar(11) = fpar(11) + n + n + 2
      else
         fpar(6) = fpar(5)
      endif
      if (fpar(6).gt.fpar(4) .and. (ipar(7).lt.ipar(6)
     +     .or. ipar(6).le.0)) goto 30
 100  if (ipar(3).eq.999.and.ipar(11).eq.0) goto 30
c
c     clean up
c
 900  if (rp) then
         if (ipar(1).lt.0) ipar(12) = ipar(1)
         ipar(1) = 5
         ipar(8) = 10*n + 1
         ipar(9) = ipar(8) - n
         ipar(10) = 10
         return
      endif
 110  if (rp) then
         call tidycg(n,ipar,fpar,sol,w(1,10))
      else
         call tidycg(n,ipar,fpar,sol,w(1,11))
      endif
c
      return
      end
c-----end-of-tfqmr
