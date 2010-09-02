      SUBROUTINE udsolc(n,x,y,au,jau) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------  
      INTEGER n, jau(*) 
      DOUBLE PRECISION x(n), y(n), au(*)  
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=n,1,-1
        x(k)=x(k)*au(k) 
        t=x(k) 
        do j=jau(k),jau(k+1)-1
          x(jau(j))=x(jau(j))-t*au(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOLC',2)
c     +----------------------------------------------------------------+
      return
      end
c
