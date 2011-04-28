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
      subroutine fom(n, rhs, sol, ipar, fpar, w)
      implicit none
      integer n, ipar(16)
      real*8 rhs(n), sol(n), fpar(16), w(*)
c-----------------------------------------------------------------------
c     This a version of The Full Orthogonalization Method (FOM) 
c     implemented with reverse communication. It is a simple restart 
c     version of the FOM algorithm and is implemented with plane 
c     rotations similarly to GMRES.
c
c  parameters:
c  ----------- 
c     ipar(5) == the dimension of the Krylov subspace
c     after every ipar(5) iterations, the FOM will restart with
c     the updated solution and recomputed residual vector.
c
c     the work space in `w' is used as follows:
c     (1) the basis for the Krylov subspace, size n*(m+1);
c     (2) the Hessenberg matrix, only the upper triangular
c     portion of the matrix is stored, size (m+1)*m/2 + 1
c     (3) three vectors, all are of size m, they are
c     the cosine and sine of the Givens rotations, the third one holds
c     the residuals, it is of size m+1.
c
c     TOTAL SIZE REQUIRED == (n+3)*(m+2) + (m+1)*m/2
c     Note: m == ipar(5). The default value for this is 15 if
c     ipar(5) <= 1.
c-----------------------------------------------------------------------
c     external functions used
c
      real*8 distdot
      external distdot
c
      real*8 one, zero
      parameter(one=1.0D0, zero=0.0D0)
c
c     local variables, ptr and p2 are temporary pointers,
c     hes points to the Hessenberg matrix,
c     vc, vs point to the cosines and sines of the Givens rotations
c     vrn points to the vectors of residual norms, more precisely
c     the right hand side of the least square problem solved.
c
      integer i,ii,idx,k,m,ptr,p2,prs,hes,vc,vs,vrn
      real*8 alpha, c, s 
      logical lp, rp
      save
c
c     check the status of the call
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (10, 20, 30, 40, 50, 60, 70) ipar(10)
c
c     initialization
c
      if (ipar(5).le.1) then
         m = 15
      else
         m = ipar(5)
      endif
      idx = n * (m+1)
      hes = idx + n
      vc = hes + (m+1) * m / 2 + 1
      vs = vc + m
      vrn = vs + m
      i = vrn + m + 1
      call bisinit(ipar,fpar,i,1,lp,rp,w)
      if (ipar(1).lt.0) return
c
c     request for matrix vector multiplication A*x in the initialization
c
 100  ipar(1) = 1
      ipar(8) = n+1
      ipar(9) = 1
      ipar(10) = 1
      k = 0
      do i = 1, n
         w(n+i) = sol(i)
      enddo
      return
 10   ipar(7) = ipar(7) + 1
      ipar(13) = ipar(13) + 1
      if (lp) then
         do i = 1, n
            w(n+i) = rhs(i) - w(i)
         enddo
         ipar(1) = 3
         ipar(10) = 2
         return
      else
         do i = 1, n
            w(i) = rhs(i) - w(i)
         enddo
      endif
      fpar(11) = fpar(11) + n
c
 20   alpha = sqrt(distdot(n,w,1,w,1))
      fpar(11) = fpar(11) + 2*n + 1
      if (ipar(7).eq.1 .and. ipar(3).ne.999) then
         if (abs(ipar(3)).eq.2) then
            fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
            fpar(11) = fpar(11) + 2*n
         else
            fpar(4) = fpar(1) * alpha + fpar(2)
         endif
         fpar(3) = alpha
      endif
      fpar(5) = alpha
      w(vrn+1) = alpha
      if (alpha.le.fpar(4) .and. ipar(3).ge.0 .and. ipar(3).ne.999) then
         ipar(1) = 0
         fpar(6) = alpha
         goto 300
      endif
      alpha = one / alpha
      do ii = 1, n
         w(ii) = alpha * w(ii)
      enddo
      fpar(11) = fpar(11) + n
c
c     request for (1) right preconditioning
c     (2) matrix vector multiplication
c     (3) left preconditioning
c
 110  k = k + 1
      if (rp) then
         ipar(1) = 5
         ipar(8) = k*n - n + 1
         if (lp) then
            ipar(9) = k*n + 1
         else
            ipar(9) = idx + 1
         endif
         ipar(10) = 3
         return
      endif
c
 30   ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = (k-1)*n + 1
      endif
      if (lp) then
         ipar(9) = idx + 1
      else
         ipar(9) = 1 + k*n
      endif
      ipar(10) = 4
      return
c
 40   if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = k*n + 1
         ipar(10) = 5
         return
      endif
c
c     Modified Gram-Schmidt orthogonalization procedure
c     temporary pointer 'ptr' is pointing to the current column of the
c     Hessenberg matrix. 'p2' points to the new basis vector
c
 50   ipar(7) = ipar(7) + 1
      ptr = k * (k - 1) / 2 + hes
      p2 = ipar(9)
      call mgsro(.false.,n,n,k+1,k+1,fpar(11),w,w(ptr+1),
     $     ipar(12))
      if (ipar(12).lt.0) goto 200
c
c     apply previous Givens rotations to column.
c
      p2 = ptr + 1
      do i = 1, k-1
         ptr = p2
         p2 = p2 + 1
         alpha = w(ptr)
         c = w(vc+i)
         s = w(vs+i)
         w(ptr) = c * alpha + s * w(p2)
         w(p2) = c * w(p2) - s * alpha
      enddo
c
c     end of one Arnoldi iteration, alpha will store the estimated
c     residual norm at current stage
c
      fpar(11) = fpar(11) + 6*k

      prs = vrn+k
      alpha = fpar(5) 
      if (w(p2) .ne. zero) alpha = abs(w(p2+1)*w(prs)/w(p2)) 
      fpar(5) = alpha
c
      if (k.ge.m .or. (ipar(3).ge.0 .and. alpha.le.fpar(4))
     +     .or. (ipar(6).gt.0 .and. ipar(7).ge.ipar(6)))
     +     goto 200
c
      call givens(w(p2), w(p2+1), c, s)
      w(vc+k) = c
      w(vs+k) = s
      alpha = - s * w(prs)
      w(prs) = c * w(prs)
      w(prs+1) = alpha
c
      if (w(p2).ne.zero) goto 110
c
c     update the approximate solution, first solve the upper triangular
c     system, temporary pointer ptr points to the Hessenberg matrix,
c     prs points to the right-hand-side (also the solution) of the system.
c
 200  ptr = hes + k * (k + 1) / 2
      prs = vrn + k
      if (w(ptr).eq.zero) then
c
c     if the diagonal elements of the last column is zero, reduce k by 1
c     so that a smaller trianguler system is solved
c
         k = k - 1
         if (k.gt.0) then
            goto 200
         else
            ipar(1) = -3
            ipar(12) = -4
            goto 300
         endif
      endif
      w(prs) = w(prs) / w(ptr)
      do i = k-1, 1, -1
         ptr = ptr - i - 1
         do ii = 1, i
            w(vrn+ii) = w(vrn+ii) - w(prs) * w(ptr+ii)
         enddo
         prs = prs - 1
         w(prs) = w(prs) / w(ptr)
      enddo
c
      do ii = 1, n
         w(ii) = w(ii) * w(prs)
      enddo
      do i = 1, k-1
         prs = prs + 1
         ptr = i*n
         do ii = 1, n
            w(ii) = w(ii) + w(prs) * w(ptr+ii)
         enddo
      enddo
      fpar(11) = fpar(11) + 2*(k-1)*n + n + k*(k+1)
c
      if (rp) then
         ipar(1) = 5
         ipar(8) = 1
         ipar(9) = idx + 1
         ipar(10) = 6
         return
      endif
c
 60   if (rp) then
         do i = 1, n
            sol(i) = sol(i) + w(idx+i)
         enddo
      else
         do i = 1, n
            sol(i) = sol(i) + w(i)
         enddo
      endif
      fpar(11) = fpar(11) + n
c
c     process the complete stopping criteria
c
      if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = -1
         ipar(9) = idx + 1
         ipar(10) = 7
         return
      else if (ipar(3).lt.0) then
         if (ipar(7).le.m+1) then
            fpar(3) = abs(w(vrn+1))
            if (ipar(3).eq.-1) fpar(4) = fpar(1)*fpar(3)+fpar(2)
         endif
         alpha = abs(w(vrn+k))
      endif
      fpar(6) = alpha
c
c     do we need to restart ?
c
 70   if (ipar(12).ne.0) then
         ipar(1) = -3
         goto 300
      endif
      if (ipar(7).lt.ipar(6) .or. ipar(6).le.0) then
         if (ipar(3).ne.999) then
            if (fpar(6).gt.fpar(4)) goto 100
         else
            if (ipar(11).eq.0) goto 100
         endif
      endif
c
c     termination, set error code, compute convergence rate
c
      if (ipar(1).gt.0) then
         if (ipar(3).eq.999 .and. ipar(11).eq.1) then
            ipar(1) = 0
         else if (ipar(3).ne.999 .and. fpar(6).le.fpar(4)) then
            ipar(1) = 0
         else if (ipar(7).ge.ipar(6) .and. ipar(6).gt.0) then
            ipar(1) = -1
         else
            ipar(1) = -10
         endif
      endif
 300  if (fpar(3).ne.zero .and. fpar(6).ne.zero .and.
     +     ipar(7).gt.ipar(13)) then
         fpar(7) = log10(fpar(3) / fpar(6)) / dble(ipar(7)-ipar(13))
      else
         fpar(7) = zero
      endif
      return
      end
c-----end-of-fom-------------------------------------------------------- 
