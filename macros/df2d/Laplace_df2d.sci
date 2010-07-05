function A = Laplace_df2d(u)
   execstr('[nx,ny]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   y=evstr(u.geo+'.y');
   A = spdiag([0 ones(1:ny-2),0]).*.%D2(x) ...
       + %D2(y).*.spdiag([0 ones(1:nx-2) 0]);
 endfunction
 