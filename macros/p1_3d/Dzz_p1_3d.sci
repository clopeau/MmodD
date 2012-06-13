// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Dzz_p1_3d(%u)
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  //------------- Calcul du déterminant ---------------------------------------
  execstr('invdet=(-1/6)./'+%th+'.Det');
  //-------------- Assemblage -------------------------------------------------
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,1);
  
  for i=1:4
    execstr('Tmp1='+%th+'.Shape_p1_Grad(i)(:,3)');
    tmp= Tmp1.^2 .*invdet;
    execstr('Diag=Diag+fastsparse(['+%th+'.Tet(:,i),ones(nt,1)],tmp,[nf,1])');
    //
    for j=i+1:4
     // init fonct de base j
     execstr('Tmp2='+%th+'.Shape_p1_Grad(j)(:,3)');
     tmp= Tmp1.*Tmp2 .*invdet;
     execstr('A=A+fastsparse('+%th+'.Tet(:,[i,j]),tmp,[nf,nf])');
    end
  end

  A=A+A'+diag(Diag);
endfunction

