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
