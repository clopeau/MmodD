function A=Laplace_p1nc3d(%u)
  %th=evstr(%u.geo);
  [n,nt,nf]=size(%th);
  index=[2 3; 3 1; 1 2]';
  lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
  //------------- Calcul du déterminant ---------------------------------------
  invdet=(-9*27/2)./abs(det(%th));
  //-------------- Assemblage -------------------------------------------------
  XYZ=[x_tet3d_Face(%th),y_tet3d_Face(%th),z_tet3d_Face(%th)];
  
  Tmp1=zeros(nt,3); // 1 ere fct de base
  Tmp2=zeros(nt,3); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,1);
  
  for i=1:4
    for k=1:3
      Tmp1(:,k)=(-1)^(i+1) *det2d(XYZ(:,index(:,k)),%th.Tet2Tri(:,lindex(i)));
    end

    tmp=sum(Tmp1.^2,'c') .*invdet;
    
    Diag=Diag+sparse([%th.Tet2Tri(:,i),ones(nt,1)],tmp,[nf,1]);
    //
    for j=i+1:4
     // init fonct de base j
     for k=1:3
       Tmp2(:,k)=(-1)^(j+1)*det2d(XYZ(:,index(:,k)),%th.Tet2Tri(:,lindex(j)));
     end
     tmp=sum(Tmp1.*Tmp2,'c') .*invdet;
     A=A+sparse(%th.Tet2Tri(:,[i,j]),tmp,[nf,nf]);
    end
  end
  
  clear Tmp1 Tmp2;  
  A=A+A'+diag(Diag);

endfunction

