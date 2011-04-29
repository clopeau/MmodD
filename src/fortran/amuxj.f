c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE amuxj(n,x,y,jdiag,a,ja,ia)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jdiag, ja(*), ia(*)
      DOUBLE PRECISION x(n), y(n), a(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, ii, k1, len, j 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXJ',1)
c     +----------------------------------------------------------------+
      do i=1,n
        y(i)=0.0d0
      enddo
      do ii=1,jdiag
        k1 = ia(ii)-1
        len = ia(ii+1)-k1-1
        do j=1,len
          y(j)= y(j)+a(k1+j)*x(ja(k1+j)) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXJ',2)
c     +----------------------------------------------------------------+
      return
      end
