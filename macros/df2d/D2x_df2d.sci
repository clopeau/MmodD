function A = D2x_df2d(u)
   execstr('[nx,ny]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   A = spdiag([0 ones(1:ny-2) 0]).*.%D2(x);
endfunction
