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
