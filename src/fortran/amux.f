      SUBROUTINE amux(n,x,y,a,ja,ia) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), a(*) 
      INTEGER n, ja(*), ia(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      DOUBLE PRECISION t
      INTEGER i, k
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUX',1)
c     +----------------------------------------------------------------+
      do i=1,n
c       ------------------------------------------------
c       compute the inner product of row i with vector x
c       ------------------------------------------------
        t=0.0d0
        do k=ia(i),ia(i+1)-1 
          t=t+a(k)*x(ja(k))
        enddo
c       --------------------
c       store result in y(i) 
c       --------------------
        y(i)=t
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUX',2)
c     +----------------------------------------------------------------+
      return
      end
c
