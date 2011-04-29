c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE lsolc(n,x,y,al,jal,ial)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*),ial(*) 
      DOUBLE PRECISION  x(n), y(n), al(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=1,n-1
        t=x(k) 
        do j=ial(k),ial(k+1)-1
          x(jal(j))=x(jal(j))-t*al(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOLC',2)
c     +----------------------------------------------------------------+
      return
      end
