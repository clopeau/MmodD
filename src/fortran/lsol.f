c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE lsol(n,x,y,al,jal,ial)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*),ial(n+1) 
      DOUBLE PRECISION  x(n), y(n), al(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j 
      DOUBLE PRECISION  t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOL',1)
c     +----------------------------------------------------------------+
      x(1)=y(1) 
      do k=2,n
        t=y(k) 
        do j=ial(k),ial(k+1)-1
          t=t-al(j)*x(jal(j))
        enddo
        x(k)=t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOL',2)
c     +----------------------------------------------------------------+
      return
      end
c
