 SUBROUTINE udsol(n,x,y,au,jau) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jau(*) 
      DOUBLE PRECISION  x(n), y(n),au(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOL',1)
c     +----------------------------------------------------------------+
      x(n)=y(n)*au(n)
      do k=n-1,1,-1
        t=y(k) 
        do j=jau(k),jau(k+1)-1
          t=t-au(j)*x(jau(j))
        enddo
        x(k)=au(k)*t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOL',2)
c     +----------------------------------------------------------------+
      return
      end
