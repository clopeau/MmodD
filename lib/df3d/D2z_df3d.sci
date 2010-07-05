function A = D2z_df3d(u)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   z=evstr(u.geo+'.z');
   A = %D2(z).*.spdiag([0 ones(1:ny-2) 0]).*.spdiag([0 ones(1:nx-2) 0]);
endfunction
