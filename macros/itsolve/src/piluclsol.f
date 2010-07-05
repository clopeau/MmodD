#include <ilupackmacros.h>



        subroutine PILUCLSOL(n, nB, y, x, alu, jlu, ju)
        FLOAT x(n), y(nB), alu(*)
        integer n, nB,  jlu(*), ju(n+1)
c-----------------------------------------------------------------------
c
c This routine PARTIALLY solves the system L x = y, 
c given an LDU decomposition of a matrix stored in (alu, jlu, ju) 
c modified sparse row format 
c
c-----------------------------------------------------------------------
c on entry:
c n   = total dimension of system, leading L11 block and L21 block
c nB  = dimension of the leading system 
c y   = the right-hand-side vector
c alu, jlu, ju 
c     = the LDU matrix as provided from the ILU routines. 
c
c on return
c                   /L11 0\ /x_1\  /y_1\
c x   = solution of |     | |   | =|   |.     
c                   \L21 I/ \x_2/  \ 0 /
c-----------------------------------------------------------------------
c 
c Note: routine is in place: call piluclsol (n,nB, x,x, alu,jlu,ju) 
c       will solve the system with rhs x and overwrite the result on x. 
c
c-----------------------------------------------------------------------
c Code adapted from SPARSKIT's lusol subroutine by Matthias Bollhoefer,*
c September 06, 2003, November 2004                                    *
c----------------------------------------------------------------------*
c local variables
c
        integer i,j,k
        FLOAT buff
c
c forward solve. Note that L is stored by columns!
c
        do 20 i = 1, nB
           x(i) = y(i)
 20     continue
        do 10 i = nB+1, n
           x(i) = 0.0
 10     continue

c       forward substitution with L (computed as (LD^{-1}+I))
        do 40 i = 1, nB
c          multiply by D^{-1}
           buff = x(i)*alu(i)
           do 41 k=jlu(i),ju(i)-1
              j=jlu(k)
              x(j) = x(j) - alu(k)*buff
 41        continue
 40     continue
c
        return
c----------------end of piluclsol ----------------------------------------
c-----------------------------------------------------------------------
        end
