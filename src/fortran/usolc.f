c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

      SUBROUTINE usolc(n,x,y,au,jau,iau)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), au(*) 
      INTEGER n, jau(*),iau(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('USOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=n,1,-1
        t=x(k) 
        do j=iau(k),iau(k+1)-1
          x(jau(j))=x(jau(j))-t*au(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('USOLC',2)
c     +----------------------------------------------------------------+
      return
      end
