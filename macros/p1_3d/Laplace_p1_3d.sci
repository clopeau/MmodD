// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Laplace_p1_3d(%u)
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
  //------------- Calcul du déterminant ---------------------------------------
  invdet=(-1/6)./det(%th);
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,3); // 1 ere fct de base
  Tmp2=zeros(nt,3); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,1);
  
  for i=1:4
    for k=1:3
      Tmp1(:,k)=(-1)^(i+1) *det2d(%th.Coor(:,index(:,k)),%th.Tet(:,lindex(i)));
    end

    tmp=sum(Tmp1.^2,'c') .*invdet;
    
    Diag=Diag+sparse([%th.Tet(:,i),ones(nt,1)],tmp,[nf,1]);
    //
    for j=i+1:4
     // init fonct de base j
     for k=1:3
       Tmp2(:,k)=(-1)^(j+1)*det2d(%th.Coor(:,index(:,k)),%th.Tet(:,lindex(j)));
     end
     tmp=sum(Tmp1.*Tmp2,'c') .*invdet;
     A=A+sparse(%th.Tet(:,[i,j]),tmp,[nf,nf]);
    end
  end
  clear Tmp1 Tmp2;  
  A=A+A'+diag(Diag);

endfunction

