c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE ldsoll(n,x,y,al,jal,nlev,lev,ilev) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, nlev, jal(*), ilev(nlev+1), lev(n)
      DOUBLE PRECISION x(n), y(n), al(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER ii, jrow, i, k
      DOUBLE PRECISION t 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOLL',1)
c     +----------------------------------------------------------------+
c     -----------------------------------------------------
c     outer loop goes through the levels. (SEQUENTIAL loop)
c     -----------------------------------------------------
      do ii=1,nlev
c       -------------------------------------------------------
c       next loop executes within the same level. PARALLEL loop
c       -------------------------------------------------------
        do i=ilev(ii),ilev(ii+1)-1 
          jrow=lev(i)
c         ----------------------------------------
c         compute inner product of row jrow with x
c         ----------------------------------------
          t=y(jrow) 
          do k=jal(jrow),jal(jrow+1)-1 
            t=t-al(k)*x(jal(k))
          enddo
          x(jrow)=t*al(jrow) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1)  CALL wdebg('LDSOLL',2)
c     +----------------------------------------------------------------+
      return
      end
