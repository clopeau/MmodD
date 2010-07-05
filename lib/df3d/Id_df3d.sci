function M = Id_df3d(u,opt)
   [lhs,rhs]=argn(0);
   execstr('[nx,ny,nz]=size('+u.geo+')');
   if rhs==1
     M=spdiag([0 ones(1:nz-2) 0]).*.spdiag([0 ones(1:ny-2),0]).*. spdiag([0 ones(1:nx-2),0]);
   else
     ind=evstr(u.geo+'('''+opt+''')');
     M=sparse([ind,ind],ones(ind),[nx*ny*nz,nx*ny*nz]);
   end
endfunction
 