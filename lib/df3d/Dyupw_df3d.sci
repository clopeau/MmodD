function A = Dyupw_df3d(v,u)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   y=evstr(u.geo+'.y');
   Ap =spdiag([0 ones(1:nz-2) 0]).*.%D(y,'+').*.spdiag([0 ones(1:nx-2) 0]);
   Am =spdiag([0 ones(1:nz-2) 0]).*.%D(y,'-').*.spdiag([0 ones(1:nx-2) 0]);
   ind=v.Node>0
   A=spzeros(nx*ny*nz,nx*ny*nz);
   A(ind,:)=Ap(ind,:);
   ind=~ind;
   A(ind,:)=Am(ind,:);
   clear Ap Am
   A=v*A;
endfunction
 
