function A = Dxupw_df3d(v,u)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   x=evstr(u.geo+'.x');
   Ap = spdiag([0 ones(1:nz-2) 0]).*.spdiag([0 ones(1:ny-2) 0]).*.%D(x,'+');
   Am = spdiag([0 ones(1:nz-2) 0]).*.spdiag([0 ones(1:ny-2) 0]).*.%D(x,'-');
   ind=v.Node>0
   A=spzeros(nx*ny*nz,nx*ny*nz);
   A(ind,:)=Ap(ind,:);
   ind=~ind;
   A(ind,:)=Am(ind,:);
   clear Ap Am
   A=v*A;
endfunction
