function A = Dy_df2d(u,sig)
   [lhs,rhs] = argn(0)
   if rhs==1
     sig='c'
   end
   
   execstr('[nx,ny]=size('+u.geo+')');
   y=evstr(u.geo+'.y');
   A = %D(y,sig).*.spdiag([0 ones(1:nx-2) 0]);

endfunction
 
