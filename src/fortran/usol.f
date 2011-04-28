c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE usol(n,x,y,au,jau,iau)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jau(*),iau(n+1) 
      DOUBLE PRECISION  x(n), y(n), au(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j 
      DOUBLE PRECISION  t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1)  CALL wdebg('USOL',1)
c     +----------------------------------------------------------------+
      x(n)=y(n) 
      do k=n-1,1,-1 
        t=y(k) 
        do j=iau(k),iau(k+1)-1
          t=t-au(j)*x(jau(j))
        enddo
        x(k)=t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('USOL',2)
c     +----------------------------------------------------------------+
      return
      end
