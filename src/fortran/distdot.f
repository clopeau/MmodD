c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


      FUNCTION distdot(n,x,ix,y,iy)
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      integer n, ix, iy
      DOUBLE PRECISION distdot, x(*), y(*), ddot
      external ddot
c     +----------------------------------------------------------------+
      distdot=ddot(n,x,ix,y,iy)
c     +----------------------------------------------------------------+
      return
      end
