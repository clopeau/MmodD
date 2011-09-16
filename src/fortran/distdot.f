c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c

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
