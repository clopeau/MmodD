function A=Gradient_df3d(u,K)
   [lhs,rhs]=argn(0);
   if rhs==1
     K=eye(3,3)
   end
   
   execstr('[nx,ny,nz]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   y=evstr(u.geo+'.y');
   z=evstr(u.geo+'.z');

   Ax = spdiag([0 ones(1:nz-2),0]).*.spdiag([0 ones(1:ny-2),0]).*.%D(x,'c');
   Ay = spdiag([0 ones(1:nz-2),0]).*.%D(y,'c').*.spdiag([0 ones(1:nx-2) 0]);
   Az = %D(z,'c').*.spdiag([0 ones(1:ny-2),0]).*.spdiag([0 ones(1:nx-2),0]);

   A=[Ax;Ay;Az]
endfunction
 