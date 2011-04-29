c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      SUBROUTINE amuxe(n,x,y,na,ncol,a,ja) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER  n, na, ncol, ja(na,*)
      DOUBLE PRECISION x(n), y(n), a(na,*)  
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, j 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXE',1)
c     +----------------------------------------------------------------+
      do i=1,n
        y(i)=0.0 
      enddo
      do j=1,ncol
        do i=1,n
          y(i)=y(i)+a(i,j)*x(ja(i,j))
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXE',2)
c     +----------------------------------------------------------------+
      return
      end
