c      Copyright (C) 2010-11 - Thierry Clopeau
c      This file must be used under the terms of the CeCILL.
c      This source file is licensed as described in the file COPYING, which
c      you should have received as part of this distribution. The terms
c      are also available at
c      http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


        subroutine lutsol(n, y, x, alu, jlu, ju) 
        real*8 x(n), y(n), alu(*)
	integer n, jlu(*), ju(*)
c-----------------------------------------------------------------------
c
c This routine solves the system  Transp(LU) x = y,
c given an LU decomposition of a matrix stored in (alu, jlu, ju) 
c modified sparse row format. Transp(M) is the transpose of M. 
c----------------------------------------------------------------------- 
c on entry:
c n   = dimension of system 
c y   = the right-hand-side vector
c alu, jlu, ju 
c     = the LU matrix as provided from the ILU routines. 
c
c on return
c x   = solution of transp(LU) x = y.   
c-----------------------------------------------------------------------
c
c Note: routine is in place: call lutsol (n, x, x, alu, jlu, ju) 
c       will solve the system with rhs x and overwrite the result on x . 
c 
c-----------------------------------------------------------------------
c local variables
c
        integer i,k
c
        do 10 i = 1, n
           x(i) = y(i)
 10     continue
c
c forward solve (with U^T)
c
        do 20 i = 1, n
           x(i) = x(i) * alu(i)
           do 30 k=ju(i),jlu(i+1)-1
              x(jlu(k)) = x(jlu(k)) - alu(k)* x(i)
 30        continue
 20     continue
c     
c     backward solve (with L^T)
c     
	do 40 i = n, 1, -1 
	   do 50 k=jlu(i),ju(i)-1
              x(jlu(k)) = x(jlu(k)) - alu(k)*x(i)
 50        continue
 40     continue
c
  	return
c----------------end of lutsol -----------------------------------------
c-----------------------------------------------------------------------
	end
