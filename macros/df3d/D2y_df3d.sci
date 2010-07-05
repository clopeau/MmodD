function A = D2y_df3d(u)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   y=evstr(u.geo+'.y');
   A = spdiag([0 ones(1:nz-2) 0]).*.%D2(y).*.spdiag([0 ones(1:nx-2) 0]);
endfunction
