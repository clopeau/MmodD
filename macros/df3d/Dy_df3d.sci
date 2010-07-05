function A = Dy_df3d(u,sig)
   [lhs,rhs] = argn(0)
   if rhs==1
     sig='c'
   end
   
   execstr('[nx,ny,nz]=size('+u.geo+')');
   y=evstr(u.geo+'.y');
   A =spdiag([0 ones(1:nz-2) 0]).*.%D(y,sig).*.spdiag([0 ones(1:nx-2) 0]);

endfunction
 
