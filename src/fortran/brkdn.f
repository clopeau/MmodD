c-----------------------------------------------------------------------
      logical function brkdn(alpha, ipar)
      implicit none
      integer ipar(16)
      real*8 alpha, beta, zero, one
      parameter (zero=0.0D0, one=1.0D0)
c-----------------------------------------------------------------------
c     test whether alpha is zero or an abnormal number, if yes,
c     this routine will return .true.
c
c     If alpha == 0, ipar(1) = -3,
c     if alpha is an abnormal number, ipar(1) = -9.
c-----------------------------------------------------------------------
      brkdn = .false.
      if (alpha.gt.zero) then
         beta = one / alpha
         if (.not. beta.gt.zero) then
            brkdn = .true.
            ipar(1) = -9
         endif
      else if (alpha.lt.zero) then
         beta = one / alpha
         if (.not. beta.lt.zero) then
            brkdn = .true.
            ipar(1) = -9
         endif
      else if (alpha.eq.zero) then
         brkdn = .true.
         ipar(1) = -3
      else
         brkdn = .true.
         ipar(1) = -9
      endif
      return
      end
c-----end-of-brkdn
c-----------------------------------------------------------------------
      subroutine bisinit(ipar,fpar,wksize,dsc,lp,rp,wk)
      implicit none
      integer i,ipar(16),wksize,dsc
      logical lp,rp
      real*8  fpar(16),wk(*)
c-----------------------------------------------------------------------
c     some common initializations for the iterative solvers
c-----------------------------------------------------------------------
      real*8 zero, one
      parameter(zero=0.0D0, one=1.0D0)
c
c     ipar(1) = -2 inidcate that there are not enough space in the work
c     array
c
      if (ipar(4).lt.wksize) then
         ipar(1) = -2
         ipar(4) = wksize
         return
      endif
c
      if (ipar(2).gt.2) then
         lp = .true.
         rp = .true.
      else if (ipar(2).eq.2) then
         lp = .false.
         rp = .true.
      else if (ipar(2).eq.1) then
         lp = .true.
         rp = .false.
      else
         lp = .false.
         rp = .false.
      endif
      if (ipar(3).eq.0) ipar(3) = dsc
c     .. clear the ipar elements used
      ipar(7) = 0
      ipar(8) = 0
      ipar(9) = 0
      ipar(10) = 0
      ipar(11) = 0
      ipar(12) = 0
      ipar(13) = 0
c
c     fpar(1) must be between (0, 1), fpar(2) must be positive,
c     fpar(1) and fpar(2) can NOT both be zero
c     Normally return ipar(1) = -4 to indicate any of above error
c
      if (fpar(1).lt.zero .or. fpar(1).ge.one .or. fpar(2).lt.zero .or.
     &     (fpar(1).eq.zero .and. fpar(2).eq.zero)) then
         if (ipar(1).eq.0) then
            ipar(1) = -4
            return
         else
            fpar(1) = 1.0D-6
            fpar(2) = 1.0D-16
         endif
      endif
c     .. clear the fpar elements
      do i = 3, 10
         fpar(i) = zero
      enddo
      if (fpar(11).lt.zero) fpar(11) = zero
c     .. clear the used portion of the work array to zero
      do i = 1, wksize
         wk(i) = zero
      enddo
c
      return
c-----end-of-bisinit
      end
