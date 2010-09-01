c-----------------------------------------------------------------------
      subroutine uppdir(n,p,np,lbp,indp,y,u,usav,flops)
      real*8 p(n,lbp), y(*), u(*), usav(*), x, flops
      integer k,np,n,npm1,j,ju,indp,lbp
c-----------------------------------------------------------------------
c     updates the conjugate directions p given the upper part of the
c     banded upper triangular matrix u.  u contains the non zero
c     elements of the column of the triangular matrix..
c-----------------------------------------------------------------------
      real*8 zero
      parameter(zero=0.0D0)
c
      npm1=np-1
      if (np .le. 1) goto 12
      j=indp
      ju = npm1
 10   if (j .le. 0) j=lbp
      x = u(ju) /usav(j)
      if (x .eq. zero) goto 115
      do 11 k=1,n
         y(k) = y(k) - x*p(k,j)
 11   continue
      flops = flops + 2*n
 115  j = j-1
      ju = ju -1
      if (ju .ge. 1) goto 10
 12   indp = indp + 1
      if (indp .gt. lbp) indp = 1
      usav(indp) = u(np)
      do 13 k=1,n
         p(k,indp) = y(k)
 13   continue
 208  return
c-----------------------------------------------------------------------
c-------end-of-uppdir---------------------------------------------------
      end
      subroutine givens(x,y,c,s)
      real*8 x,y,c,s
c-----------------------------------------------------------------------
c     Given x and y, this subroutine generates a Givens' rotation c, s.
c     And apply the rotation on (x,y) ==> (sqrt(x**2 + y**2), 0).
c     (See P 202 of "matrix computation" by Golub and van Loan.)
c-----------------------------------------------------------------------
      real*8 t,one,zero
      parameter (zero=0.0D0,one=1.0D0)
c
      if (x.eq.zero .and. y.eq.zero) then
         c = one
         s = zero
      else if (abs(y).gt.abs(x)) then
         t = x / y
         x = sqrt(one+t*t)
         s = sign(one / x, y)
         c = t*s
      else if (abs(y).le.abs(x)) then
         t = y / x
         y = sqrt(one+t*t)
         c = sign(one / y, x)
         s = t*c
      else
c
c     X or Y must be an invalid floating-point number, set both to zero
c
         x = zero
         y = zero
         c = one
         s = zero
      endif
      x = abs(x*y)
c
c     end of givens
c
      return
      end
c-----end-of-givens
c-----------------------------------------------------------------------
      logical function stopbis(n,ipar,mvpi,fpar,r,delx,sx)
      implicit none
      integer n,mvpi,ipar(16)
      real*8 fpar(16), r(n), delx(n), sx, distdot
      external distdot
c-----------------------------------------------------------------------
c     function for determining the stopping criteria. return value of
c     true if the stopbis criteria is satisfied.
c-----------------------------------------------------------------------
      if (ipar(11) .eq. 1) then
         stopbis = .true.
      else
         stopbis = .false.
      endif
      if (ipar(6).gt.0 .and. ipar(7).ge.ipar(6)) then
         ipar(1) = -1
         stopbis = .true.
      endif
      if (stopbis) return
c
c     computes errors
c
      fpar(5) = sqrt(distdot(n,r,1,r,1))
      fpar(11) = fpar(11) + 2 * n
      if (ipar(3).lt.0) then
c
c     compute the change in the solution vector
c
         fpar(6) = sx * sqrt(distdot(n,delx,1,delx,1))
         fpar(11) = fpar(11) + 2 * n
         if (ipar(7).lt.mvpi+mvpi+1) then
c
c     if this is the end of the first iteration, set fpar(3:4)
c
            fpar(3) = fpar(6)
            if (ipar(3).eq.-1) then
               fpar(4) = fpar(1) * fpar(3) + fpar(2)
            endif
         endif
      else
         fpar(6) = fpar(5)
      endif
c
c     .. the test is struct this way so that when the value in fpar(6)
c       is not a valid number, STOPBIS is set to .true.
c
      if (fpar(6).gt.fpar(4)) then
         stopbis = .false.
         ipar(11) = 0
      else
         stopbis = .true.
         ipar(11) = 1
      endif
c
      return
      end
c-----end-of-stopbis
