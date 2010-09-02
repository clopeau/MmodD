      SUBROUTINE amuxms(n,x,y,a,ja)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), a(*)
      INTEGER n, ja(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, k
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXMS',1)
c     +----------------------------------------------------------------+
      do i=1,n
        y(i)=a(i)*x(i)
      enddo
      do i=1,n
c       ------------------------------------------------
c       compute the inner product of row i with vector x
c       ------------------------------------------------
        do k=ja(i),ja(i+1)-1
          y(i)=y(i)+a(k)*x(ja(k))
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXMS',2)
c     +----------------------------------------------------------------+
      return
      end
c
