function M = Id_df1d(u,Bnd)
  [lhs,rhs]=argn(0);
  execstr('nx=size('+u.geo+')');
  if rhs==1
    M = spdiag([0 ones(1:nx-2),0]);
  else
    ind=evstr(u.geo+'('''+Bnd+''')');
    M=sparse([ind,ind],1,[nx,nx]);
  end   
endfunction
