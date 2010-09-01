c-----------------------------------------------------------------------
      subroutine dbcg (n,rhs,sol,ipar,fpar,w)
      implicit none
      integer n,ipar(16)
      real*8 rhs(n), sol(n), fpar(16), w(n,*)
c-----------------------------------------------------------------------
c Quasi GMRES method for solving a linear
c system of equations a * sol = y.  double precision version.
c this version is without restarting and without preconditioning.
c parameters :
c -----------
c n     = dimension of the problem
c
c y     = w(:,1) a temporary storage used for various operations
c z     = w(:,2) a work vector of length n.
c v     = w(:,3:4) size n x 2
c w     = w(:,5:6) size n x 2
c p     = w(:,7:9) work array of dimension n x 3
c del x = w(:,10)  accumulation of the changes in solution
c tmp   = w(:,11)  a temporary vector used to hold intermediate result of
c                  preconditioning, etc.
c
c sol   = the solution of the problem . at input sol must contain an
c         initial guess to the solution.
c    ***  note:   y is destroyed on return.
c
c-----------------------------------------------------------------------
c subroutines and functions called:
c 1) matrix vector multiplication and preconditioning through reverse
c     communication
c
c 2) implu, uppdir, distdot (blas)
c-----------------------------------------------------------------------
c aug. 1983  version.    author youcef saad. yale university computer
c science dept. some  changes made july 3, 1986.
c references: siam j. sci. stat. comp., vol. 5, pp. 203-228 (1984)
c-----------------------------------------------------------------------
c     local variables
c
      real*8 one,zero
      parameter(one=1.0D0,zero=0.0D0)
c
      real*8 t,sqrt,distdot,ss,res,beta,ss1,delta,x,zeta,umm
      integer k,j,i,i2,ip2,ju,lb,lbm1,np,indp
      logical lp,rp,full, perm(3)
      real*8 ypiv(3),u(3),usav(3)
      external tidycg
      save
c
c     where to go
c
      if (ipar(1).le.0) ipar(10) = 0
      goto (110, 120, 130, 140, 150, 160, 170, 180, 190, 200) ipar(10)
c
c     initialization, parameter checking, clear the work arrays
c
      call bisinit(ipar,fpar,11*n,1,lp,rp,w)
      if (ipar(1).lt.0) return
      perm(1) = .false.
      perm(2) = .false.
      perm(3) = .false.
      usav(1) = zero
      usav(2) = zero
      usav(3) = zero
      ypiv(1) = zero
      ypiv(2) = zero
      ypiv(3) = zero
c-----------------------------------------------------------------------
c     initialize constants for outer loop :
c-----------------------------------------------------------------------
      lb = 3
      lbm1 = 2
c
c     get initial residual vector and norm
c
      ipar(1) = 1
      ipar(8) = 1
      ipar(9) = 1 + n
      do i = 1, n
         w(i,1) = sol(i)
      enddo
      ipar(10) = 1
      return
 110  ipar(7) = ipar(7) + 1
      ipar(13) = ipar(13) + 1
      if (lp) then
         do i = 1, n
            w(i,1) = rhs(i) - w(i,2)
         enddo
         ipar(1) = 3
         ipar(8) = 1
         ipar(9) = n+n+1
         ipar(10) = 2
         return
      else
         do i = 1, n
            w(i,3) = rhs(i) - w(i,2)
         enddo
      endif
      fpar(11) = fpar(11) + n
c
 120  fpar(3) = sqrt(distdot(n,w(1,3),1,w(1,3),1))
      fpar(11) = fpar(11) + n + n
      fpar(5) = fpar(3)
      fpar(7) = fpar(3)
      zeta = fpar(3)
      if (abs(ipar(3)).eq.2) then
         fpar(4) = fpar(1) * sqrt(distdot(n,rhs,1,rhs,1)) + fpar(2)
         fpar(11) = fpar(11) + 2*n
      else if (ipar(3).ne.999) then
         fpar(4) = fpar(1) * zeta + fpar(2)
      endif
      if (ipar(3).ge.0.and.fpar(5).le.fpar(4)) then
         fpar(6) = fpar(5)
         goto 900
      endif
c
c     normalize first arnoldi vector
c
      t = one/zeta
      do 22 k=1,n
         w(k,3) = w(k,3)*t
         w(k,5) = w(k,3)
 22   continue
      fpar(11) = fpar(11) + n
c
c     initialize constants for main loop
c
      beta = zero
      delta = zero
      i2 = 1
      indp = 0
      i = 0
c
c     main loop: i = index of the loop.
c
c-----------------------------------------------------------------------
 30   i = i + 1
c
      if (rp) then
         ipar(1) = 5
         ipar(8) = (1+i2)*n+1
         if (lp) then
            ipar(9) = 1
         else
            ipar(9) = 10*n + 1
         endif
         ipar(10) = 3
         return
      endif
c
 130  ipar(1) = 1
      if (rp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = (1+i2)*n + 1
      endif
      if (lp) then
         ipar(9) = 10*n + 1
      else
         ipar(9) = 1
      endif
      ipar(10) = 4
      return
c
 140  if (lp) then
         ipar(1) = 3
         ipar(8) = ipar(9)
         ipar(9) = 1
         ipar(10) = 5
         return
      endif
c
c     A^t * x
c
 150  ipar(7) = ipar(7) + 1
      if (lp) then
         ipar(1) = 4
         ipar(8) = (3+i2)*n + 1
         if (rp) then
            ipar(9) = n + 1
         else
            ipar(9) = 10*n + 1
         endif
         ipar(10) = 6
         return
      endif
c
 160  ipar(1) = 2
      if (lp) then
         ipar(8) = ipar(9)
      else
         ipar(8) = (3+i2)*n + 1
      endif
      if (rp) then
         ipar(9) = 10*n + 1
      else
         ipar(9) = n + 1
      endif
      ipar(10) = 7
      return
c
 170  if (rp) then
         ipar(1) = 6
         ipar(8) = ipar(9)
         ipar(9) = n + 1
         ipar(10) = 8
         return
      endif
c-----------------------------------------------------------------------
c     orthogonalize current v against previous v's and
c     determine relevant part of i-th column of u(.,.) the
c     upper triangular matrix --
c-----------------------------------------------------------------------
 180  ipar(7) = ipar(7) + 1
      u(1) = zero
      ju = 1
      k = i2
      if (i .le. lbm1) ju = 0
      if (i .lt. lb) k = 0
 31   if (k .eq. lbm1) k=0
      k=k+1
c
      if (k .ne. i2) then
         ss  = delta
         ss1 = beta
         ju = ju + 1
         u(ju) = ss
      else
         ss = distdot(n,w(1,1),1,w(1,4+k),1)
         fpar(11) = fpar(11) + 2*n
         ss1= ss
         ju = ju + 1
         u(ju) = ss
      endif
c
      do 32  j=1,n
         w(j,1) = w(j,1) - ss*w(j,k+2)
         w(j,2) = w(j,2) - ss1*w(j,k+4)
 32   continue
      fpar(11) = fpar(11) + 4*n
c
      if (k .ne. i2) goto 31
c
c     end of Mod. Gram. Schmidt loop
c
      t = distdot(n,w(1,2),1,w(1,1),1)
c
      beta   = sqrt(abs(t))
      delta  = t/beta
c
      ss = one/beta
      ss1 = one/ delta
c
c     normalize and insert new vectors
c
      ip2 = i2
      if (i2 .eq. lbm1) i2=0
      i2=i2+1
c
      do 315 j=1,n
         w(j,i2+2)=w(j,1)*ss
         w(j,i2+4)=w(j,2)*ss1
 315  continue
      fpar(11) = fpar(11) + 4*n
c-----------------------------------------------------------------------
c     end of orthogonalization.
c     now compute the coefficients u(k) of the last
c     column of the  l . u  factorization of h .
c-----------------------------------------------------------------------
      np = min0(i,lb)
      full = (i .ge. lb)
      call implu(np, umm, beta, ypiv, u, perm, full)
c-----------------------------------------------------------------------
c     update conjugate directions and solution
c-----------------------------------------------------------------------
      do 33 k=1,n
         w(k,1) = w(k,ip2+2)
 33   continue
      call uppdir(n, w(1,7), np, lb, indp, w, u, usav, fpar(11))
c-----------------------------------------------------------------------
      if (i .eq. 1) goto 34
      j = np - 1
      if (full) j = j-1
      if (.not.perm(j)) zeta = -zeta*ypiv(j)
 34   x = zeta/u(np)
      if (perm(np))goto 36
      do 35 k=1,n
         w(k,10) = w(k,10) + x*w(k,1)
 35   continue
      fpar(11) = fpar(11) + 2 * n
c-----------------------------------------------------------------------
 36   if (ipar(3).eq.999) then
         ipar(1) = 10
         ipar(8) = 9*n + 1
         ipar(9) = 10*n + 1
         ipar(10) = 9
         return
      endif
      res = abs(beta*zeta/umm)
      fpar(5) = res * sqrt(distdot(n, w(1,i2+2), 1, w(1,i2+2), 1))
      fpar(11) = fpar(11) + 2 * n
      if (ipar(3).lt.0) then
         fpar(6) = x * sqrt(distdot(n,w,1,w,1))
         fpar(11) = fpar(11) + 2 * n
         if (ipar(7).le.3) then
            fpar(3) = fpar(6)
            if (ipar(3).eq.-1) then
               fpar(4) = fpar(1) * sqrt(fpar(3)) + fpar(2)
            endif
         endif
      else
         fpar(6) = fpar(5)
      endif
c---- convergence test -----------------------------------------------
 190  if (ipar(3).eq.999.and.ipar(11).eq.0) then
         goto 30
      else if (fpar(6).gt.fpar(4) .and. (ipar(6).gt.ipar(7) .or.
     +        ipar(6).le.0)) then
         goto 30
      endif
c-----------------------------------------------------------------------
c     here the fact that the last step is different is accounted for.
c-----------------------------------------------------------------------
      if (.not. perm(np)) goto 900
      x = zeta/umm
      do 40 k = 1,n
         w(k,10) = w(k,10) + x*w(k,1)
 40   continue
      fpar(11) = fpar(11) + 2 * n
c
c     right preconditioning and clean-up jobs
c
 900  if (rp) then
         if (ipar(1).lt.0) ipar(12) = ipar(1)
         ipar(1) = 5
         ipar(8) = 9*n + 1
         ipar(9) = ipar(8) + n
         ipar(10) = 10
         return
      endif
 200  if (rp) then
         call tidycg(n,ipar,fpar,sol,w(1,11))
      else
         call tidycg(n,ipar,fpar,sol,w(1,10))
      endif
      return
      end
c-----end-of-dbcg-------------------------------------------------------
c-----------------------------------------------------------------------
      subroutine implu(np,umm,beta,ypiv,u,permut,full)
      real*8 umm,beta,ypiv(*),u(*),x, xpiv
      logical full, perm, permut(*)
      integer np,k,npm1
c-----------------------------------------------------------------------
c     performs implicitly one step of the lu factorization of a
c     banded hessenberg matrix.
c-----------------------------------------------------------------------
      if (np .le. 1) goto 12
      npm1 = np - 1
c
c     -- perform  previous step of the factorization-
c
      do 6 k=1,npm1
         if (.not. permut(k)) goto 5
         x=u(k)
         u(k) = u(k+1)
         u(k+1) = x
 5       u(k+1) = u(k+1) - ypiv(k)*u(k)
 6    continue
c-----------------------------------------------------------------------
c     now determine pivotal information to be used in the next call
c-----------------------------------------------------------------------
 12   umm = u(np)
      perm = (beta .gt. abs(umm))
      if (.not. perm) goto 4
      xpiv = umm / beta
      u(np) = beta
      goto 8
 4    xpiv = beta/umm
 8    permut(np) = perm
      ypiv(np) = xpiv
      if (.not. full) return
c     shift everything up if full...
      do 7 k=1,npm1
         ypiv(k) = ypiv(k+1)
         permut(k) = permut(k+1)
 7    continue
      return
c-----end-of-implu
      end
