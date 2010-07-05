function A = Dz_df3d(u,sig)
   [lhs,rhs] = argn(0)
   if rhs==1
     sig='c'
   end
   
   execstr('[nx,ny,nz]=size('+u.geo+')');
   z=evstr(u.geo+'.z');
   A = %D(z,sig).*.spdiag([0 ones(1:ny-2) 0]).*.spdiag([0 ones(1:nx-2) 0]);

endfunction
 
