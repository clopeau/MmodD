c-----------------------------------------------------------------------
      subroutine tidycg(n,ipar,fpar,sol,delx)
      implicit none
      integer i,n,ipar(16)
      real*8 fpar(16),sol(n),delx(n)
c-----------------------------------------------------------------------
c     Some common operations required before terminating the CG routines
c-----------------------------------------------------------------------
      real*8 zero
      parameter(zero=0.0D0)
c
      if (ipar(12).ne.0) then
         ipar(1) = ipar(12) 
      else if (ipar(1).gt.0) then
         if ((ipar(3).eq.999 .and. ipar(11).eq.1) .or.
     +        fpar(6).le.fpar(4)) then
            ipar(1) = 0
         else if (ipar(7).ge.ipar(6) .and. ipar(6).gt.0) then
            ipar(1) = -1
         else
            ipar(1) = -10
         endif
      endif
      if (fpar(3).gt.zero .and. fpar(6).gt.zero .and.
     +     ipar(7).gt.ipar(13)) then
         fpar(7) = log10(fpar(3) / fpar(6)) / dble(ipar(7)-ipar(13))
      else
         fpar(7) = zero
      endif
      do i = 1, n
         sol(i) = sol(i) + delx(i)
      enddo
      return
      end
c-----end-of-tidycg
