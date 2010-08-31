        subroutine PILUCDUSOL(n, nB, y, x, alu, jlu, ju)
        DOUBLE PRECISION x(n), y(nB), alu(*)
        integer n, nB, jlu(*), ju(n+1)
c-----------------------------------------------------------------------
c
c This routine PARTIALLY solves the system (DU) x = y, 
c given an LDU decomposition of a matrix stored in (alu, jlu, ju) 
c modified sparse row format 
c
c-----------------------------------------------------------------------
c on entry:
c n   = total dimension of system, leading U11 block and U12 block
c nB  = dimension of the leading system 
c y   = the right-hand-side vector
c alu, jlu, ju 
c     = the LDU matrix as provided from the ILU routines. 
c
c on return
c                   /D11 0\ /U11 U12\ /x_1\   /y_1\
c x_1 = solution of |     | |       | |   | = |   |.     
c                   \0   I/ \ 0   I / \y_2/   \y_2/
c-----------------------------------------------------------------------
c 
c Note: routine is in place: call pilucdusol (n,nB, x,x, alu,jlu,ju) 
c       will solve the system with rhs x and overwrite the result on x. 
c
c-----------------------------------------------------------------------
c Code adapted from SPARSKIT's lusol subroutine by Matthias Bollhoefer,*
c September 06, 2003, November 2004                                    *
c----------------------------------------------------------------------*
c local variables
c
        integer i,j,k
        DOUBLE PRECISION buff
c
c forward solve. Note that U is stored by rows!
c
        do 20 i = 1, nB
           x(i) = y(i)
 20     continue
c
c     backward solve with DU (stored as D+U).
c
        do 90 i = nB, 1, -1
           do 91 k=ju(i),jlu(i+1)-1
              x(i) = x(i) - alu(k)*x(jlu(k))
 91        continue
c          divide by the diagonal entry
           x(i) = alu(i)*x(i)
 90     continue
c
        return
c----------------end of pilucdusol -------------------------------------
c-----------------------------------------------------------------------
        end
