c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
      subroutine givens(x,y,c,s)
      real*8 x,y,c,s
c-----------------------------------------------------------------------
c     Given x and y, this subroutine generates a Givens' rotation c, s.
c     And apply the rotation on (x,y) ==> (sqrt(x**2 + y**2), 0).
c     (See P 202 of "matrix computation" by Golub and van Loan.)
c-----------------------------------------------------------------------
      real*8 t,one,zero
      parameter (zero=0.0D0,one=1.0D0)
c
      if (x.eq.zero .and. y.eq.zero) then
         c = one
         s = zero
      else if (abs(y).gt.abs(x)) then
         t = x / y
         x = sqrt(one+t*t)
         s = sign(one / x, y)
         c = t*s
      else if (abs(y).le.abs(x)) then
         t = y / x
         y = sqrt(one+t*t)
         c = sign(one / y, x)
         s = t*c
      else
c
c     X or Y must be an invalid floating-point number, set both to zero
c
         x = zero
         y = zero
         c = one
         s = zero
      endif
      x = abs(x*y)
c
c     end of givens
c
      return
      end
c-----end-of-givens
