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
      subroutine bcg(n,rhs,sol,ipar,fpar,w)
      implicit none
      integer n, ipar(16)
      real*8  fpar(16), rhs(n), sol(n), w(n,*)
c-----------------------------------------------------------------------
c     BCG: Bi Conjugate Gradient method. Programmed with reverse
c     communication, see the header for detailed specifications
c     of the protocol.
c
c     in this routine, before successful return, the fpar's are
c     fpar(3) == initial residual norm
c     fpar(4) == target residual norm
c     fpar(5) == current residual norm
c     fpar(7) == current rho (rhok = <r, s>)
c     fpar(8) == previous rho (rhokm1)
c
c     w(:,1) -- r, the residual
c     w(:,2) -- s, the dual of the 'r'
c     w(:,3) -- p, the projection direction
c     w(:,4) -- q, the dual of the 'p'
c     w(:,5) -- v, a scratch vector to store A*p, or A*q.
c     w(:,6) -- a scratch vector to store intermediate results
c     w(:,7) -- changes in the solution
c-----------------------------------------------------------------------
c     external routines used
c
      real*8 distdot
      logical stopbis,brkdn
      external distdot, stopbis, brkdn
c
      real*8 one
      parameter(one=1.0D0)
c
c     local variables
c
      integer i
      real*8 alpha
      logical rp, lp
      save
c
c     status of the program
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (10, 20, 40, 50, 60, 70, 80, 90, 100, 110), ipar(10)
c
c     initialization, initial residual
c
      call bisinit(ipar,fpar,7*n,1,lp,rp,w)
      if (ipar(1).lt.0) return
c
c     compute initial residual, request a matvecc
c
      ipar(1) = 1
      ipar(8) = 3*n+1
      ipar(9) = ipar(8) + n
      do i = 1, n
         w(i,4) = sol(i)
      enddo
      ipar(10) = 1
      return
 10   ipar(7) = ipar(7) + 1
      ipar(13) = ipar(13) + 1
      do i = 1, n
         w(i,1) = rhs(i) - w(i,5)
      enddo
      fpar(11) = fpar(11) + n
      if (lp) then
         ipar(1) = 3
         ipar(8) = 1
         ipar(9) = n+1
         ipar(10) = 2
         return
      endif
c
 20   if (lp) then
         do i = 1, n
            w(i,1) = w(i,2)
            w(i,3) = w(i,2)
            w(i,4) = w(i,2)
         enddo
      else
         do i = 1, n
            w(i,2) = w(i,1)
            w(i,3) = w(i,1)
            w(i,4) = w(i,1)
         enddo
      endif
c
      fpar(7) = distdot(n,w,1,w,1)
      fpar(11) = fpar(11) + 2 * n
      fpar(3) = sqrt(fpar(7))
      fpar(5) = fpar(3)
      fpar(8) = one
      if (abs(ipar(3)).eq.2) then
         fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
         fpar(11) = fpar(11) + 2 * n
      else if (ipar(3).ne.999) then
         fpar(4) = fpar(1) * fpar(3) + fpar(2)
      endif
      if (ipar(3).ge.0.and.fpar(5).le.fpar(4)) then
         fpar(6) = fpar(5)
         goto 900
      endif
c
c     end of initialization, begin iteration, v = A p
c
 30   if (rp) then
         ipar(1) = 5
         ipar(8) = n + n + 1
         if (lp) then
            ipar(9) = 4*n + 1
         else
            ipar(9) = 5*n + 1
         endif
         ipar(10) = 3
         return
      endif
c
 40   ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = n + n + 1
      endif
      if (lp) then
         ipar(9) = 5*n + 1
      else
         ipar(9) = 4*n + 1
      endif
      ipar(10) = 4
      return
c
 50   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = 4*n + 1
         ipar(10) = 5
         return
      endif
c
 60   ipar(7) = ipar(7) + 1
      alpha = distdot(n,w(1,4),1,w(1,5),1)
      fpar(11) = fpar(11) + 2 * n
      if (brkdn(alpha,ipar)) goto 900
      alpha = fpar(7) / alpha
      do i = 1, n
         w(i,7) = w(i,7) + alpha * w(i,3)
         w(i,1) = w(i,1) - alpha * w(i,5)
      enddo
      fpar(11) = fpar(11) + 4 * n
      if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = 6*n + 1
         ipar(9) = 5*n + 1
         ipar(10) = 6
         return
      endif
 70   if (ipar(3).eq.999) then
         if (ipar(11).eq.1) goto 900
      else if (stopbis(n,ipar,1,fpar,w,w(1,3),alpha)) then
         goto 900
      endif
c
c     A^t * x
c
      if (lp) then
         ipar(1) = 4
         ipar(8) = 3*n + 1
         if (rp) then
            ipar(9) = 4*n + 1
         else
            ipar(9) = 5*n + 1
         endif
         ipar(10) = 7
         return
      endif
c
 80   ipar(1) = 2
      if (lp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = 3*n + 1
      endif
      if (rp) then
         ipar(9) = 5*n + 1
      else
         ipar(9) = 4*n + 1
      endif
      ipar(10) = 8
      return
c
 90   if (rp) then
         ipar(1) = 6
         ipar(8) = ipar(9)
         ipar(9) = 4*n + 1
         ipar(10) = 9
         return
      endif
c
 100  ipar(7) = ipar(7) + 1
      do i = 1, n
         w(i,2) = w(i,2) - alpha * w(i,5)
      enddo
      fpar(8) = fpar(7)
      fpar(7) = distdot(n,w,1,w(1,2),1)
      fpar(11) = fpar(11) + 4 * n
      if (brkdn(fpar(7), ipar)) return
      alpha = fpar(7) / fpar(8)
      do i = 1, n
         w(i,3) = w(i,1) + alpha * w(i,3)
         w(i,4) = w(i,2) + alpha * w(i,4)
      enddo
      fpar(11) = fpar(11) + 4 * n
c
c     end of the iterations
c
      goto 30
c
c     some clean up job to do
c
 900  if (rp) then
         if (ipar(1).lt.0) ipar(12) = ipar(1)
         ipar(1) = 5
         ipar(8) = 6*n + 1
         ipar(9) = ipar(8) - n
         ipar(10) = 10
         return
      endif
 110  if (rp) then
         call tidycg(n,ipar,fpar,sol,w(1,6))
      else
         call tidycg(n,ipar,fpar,sol,w(1,7))
      endif
      return
c-----end-of-bcg
      end
