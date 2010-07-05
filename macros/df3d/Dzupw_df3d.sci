function A = Dzupw_df3d(u,sig)
   execstr('[nx,ny,nz]=size('+u.geo+')');
   z=evstr(u.geo+'.z');
   Ap = %D(z,'+').*.spdiag([0 ones(1:ny-2) 0]).*.spdiag([0 ones(1:nx-2) 0]);
   Am = %D(z,'-').*.spdiag([0 ones(1:ny-2) 0]).*.spdiag([0 ones(1:nx-2) 0]);
   ind=v.Node>0
   A=spzeros(nx*ny*nz,nx*ny*nz);
   A(ind,:)=Ap(ind,:);
   ind=~ind;
   A(ind,:)=Am(ind,:);
   clear Ap Am
   A=v*A;
endfunction
 
