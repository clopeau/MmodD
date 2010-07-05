function M = Id_df2d(u,opt)
   [lhs,rhs]=argn(0);
   execstr('[nx,ny]=size('+u.geo+')');
   if rhs==1
     M = spdiag([0 ones(1:ny-2),0]).*. spdiag([0 ones(1:nx-2) 0]);
   else
     ind=evstr(u.geo+'('''+opt+''')');
     M=sparse([ind,ind],ones(ind),[nx*ny,nx*ny]);
   end   
endfunction
