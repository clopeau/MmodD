c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


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
