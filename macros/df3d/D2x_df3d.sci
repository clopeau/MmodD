function A = D2x_df3d(u)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   A = spdiag([0 ones(1:nz-2) 0]).*.spdiag([0 ones(1:ny-2) 0]).*.%D2(x);
endfunction
