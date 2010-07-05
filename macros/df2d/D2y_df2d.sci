function A = D2y_df2d(u)
   execstr('[nx,ny]=size('+u.geo+')');
   y=evstr(u.geo+'.y');
   A = %D2(y).*.spdiag([0 ones(1:nx-2) 0]);
endfunction
