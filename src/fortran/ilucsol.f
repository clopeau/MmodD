c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
        subroutine ilucsol(n, y, x, alu, jlu, ju)
        double precision  x(n), y(n), alu(*)
        integer n, jlu(*), ju(n+1)
c-----------------------------------------------------------------------
c
c This routine solves the system (LU) x = y, 
c given an LU decomposition of a matrix stored in (alu, jlu, ju) 
c modified sparse row format 
c
c-----------------------------------------------------------------------
c on entry:
c n   = dimension of system 
c y   = the right-hand-side vector
c alu, jlu, ju 
c     = the LU matrix as provided from the ILU routines. 
c
c on return
c x   = solution of LU x = y.     
c-----------------------------------------------------------------------
c 
c Note: routine is in place: call ilucsol (n, x, x, alu, jlu, ju) 
c       will solve the system with rhs x and overwrite the result on x. 
c
c-----------------------------------------------------------------------
c Code adapted from SPARSKIT's lusol subroutine by Matthias Bollhoefer,*
c August 23, 2002                                                      *
c----------------------------------------------------------------------*
c local variables
c
        integer i,j,k
        real*8 buff
c
c forward solve. Note that L is stored by columns!
c
        do 20 i = 1, n
           x(i) = y(i)
 20     continue
        do 40 i = 1, n
           buff = x(i)*alu(i)
           do 41 k=jlu(i),ju(i)-1
              j=jlu(k)
              x(j) = x(j) - alu(k)*buff
 41        continue
 40     continue
c
c     backward solve.
c
        do 90 i = n, 1, -1
           do 91 k=ju(i),jlu(i+1)-1
              x(i) = x(i) - alu(k)*x(jlu(k))
 91        continue
c           x(i) = alu(i)*x(i)
 90     continue
c
        return
c----------------end of ilucsol ----------------------------------------
c-----------------------------------------------------------------------
        end
