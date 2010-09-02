      SUBROUTINE ldsolc(n,x,y,al,jal) 
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
c      IF (debug.eq.1) CALL wdebg('LDSOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=1,n 
        x(k)=x(k)*al(k) 
        t=x(k) 
        do j=jal(k),jal(k+1)-1
          x(jal(j))=x(jal(j))-t*al(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOLC',2)
c     +----------------------------------------------------------------+
      return
      end
