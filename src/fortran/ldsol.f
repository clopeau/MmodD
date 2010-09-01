 SUBROUTINE ldsol(n,x,y,al,jal) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*) 
      DOUBLE PRECISION x(n), y(n), al(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j 
      DOUBLE PRECISION t 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOL',1)
c     +----------------------------------------------------------------+
      x(1)=y(1)*al(1) 
      do k=2,n
        t=y(k) 
        do j=jal(k),jal(k+1)-1
          t=t-al(j)*x(jal(j))
        enddo
        x(k) = al(k)*t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOL',2)
c     +----------------------------------------------------------------+
      return
      end
