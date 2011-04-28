c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE amux(n,x,y,a,ja,ia) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), a(*) 
      INTEGER n, ja(*), ia(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      DOUBLE PRECISION t
      INTEGER i, k
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUX',1)
c     +----------------------------------------------------------------+
      do i=1,n
c       ------------------------------------------------
c       compute the inner product of row i with vector x
c       ------------------------------------------------
        t=0.0d0
        do k=ia(i),ia(i+1)-1 
          t=t+a(k)*x(ja(k))
        enddo
c       --------------------
c       store result in y(i) 
c       --------------------
        y(i)=t
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUX',2)
c     +----------------------------------------------------------------+
      return
      end
c
