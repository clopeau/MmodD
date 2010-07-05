function A = Dyupw_df2d(v,u)
   execstr('[nx,ny]=size('+u.geo+')');
   y=evstr(u.geo+'.y');
   Ap = %D(y,'+').*.spdiag([0 ones(1:nx-2) 0]);
   Am = %D(y,'+').*.spdiag([0 ones(1:nx-2) 0]);
   ind=v.Node>0
   A=spzeros(nx*ny,nx*ny);
   A(ind,:)=Ap(ind,:);
   ind=~ind;
   A(ind,:)=Am(ind,:);
   clear Ap Am
   A=v*A;
endfunction
 
