function A = Dx_df3d(u,sig)
   [lhs,rhs] = argn(0)
   if rhs==1
     sig='c'
   end
   
   execstr('[nx,ny,nz]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   A = spdiag([0 ones(1:nz-2) 0]).*.spdiag([0 ones(1:ny-2) 0]).*.%D(x,sig);
endfunction
