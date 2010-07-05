function A = Laplace_df3d(u)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   y=evstr(u.geo+'.y');
   z=evstr(u.geo+'.z');
   
   A = spdiag([0 ones(1:nz-2),0]).*.spdiag([0 ones(1:ny-2),0]).*.%D2(x) ...
       + spdiag([0 ones(1:nz-2),0]).*.%D2(y).*.spdiag([0 ones(1:nx-2) 0])...
       + %D2(z).*.spdiag([0 ones(1:ny-2),0]).*.spdiag([0 ones(1:nx-2),0]);

 endfunction
 
 
 