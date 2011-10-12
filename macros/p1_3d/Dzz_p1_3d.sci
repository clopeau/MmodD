// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Dzz_p1_3d(%u)
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
  //------------- Calcul du déterminant ---------------------------------------
  invdet=(-1/6)./det(%th);
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,1); // 1 ere fct de base
  Tmp2=zeros(nt,1); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,1);
  
  for i=1:4
    Tmp1 =(-1)^(i+1) *det2d(%th.Coor(:,index(:,3)),%th.Tet(:,lindex(i)));

    tmp= Tmp1.^2 .*invdet;
    
    Diag=Diag+sparse([%th.Tet(:,i),ones(nt,1)],tmp,[nf,1]);
    //
    for j=i+1:4
     // init fonct de base j
     Tmp2 = (-1)^(j+1)*det2d(%th.Coor(:,index(:,3)),%th.Tet(:,lindex(j)));
     tmp= Tmp1.*Tmp2 .*invdet;
     A=A+sparse(%th.Tet(:,[i,j]),tmp,[nf,nf]);
    end
  end
  clear Tmp1 Tmp2;  
  A=A+A'+diag(Diag);

endfunction

