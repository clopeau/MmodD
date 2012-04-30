// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Laplace_p1_2d(%u)
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  //------------- Calcul du déterminant ---------------------------------------
  execstr('invdet=(-1/2) ./'+%th+'.Det')
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,2); // 1 ere fct de base
  Tmp2=zeros(nt,2); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,nf);
  
  for i=1:3
    // init fct de base i
    execstr('Tmp1='+%th+'.Shape_p1_Grad(i)');
    // Assemblage termes diagonal
    tmp=((Tmp1.*Tmp1)*[1;1])  .*invdet;
    execstr('Diag=Diag+fastsparse('+%th+'.Tri(:,[i i]),tmp,[nf,nf])');
    //
    for j=i+1:3
      // init fonct de base j
      execstr('Tmp2='+%th+'.Shape_p1_Grad(j)');
      
      tmp=((Tmp1.*Tmp2)*[1;1]) .*invdet;
      
      execstr('A=A+fastsparse('+%th+'.Tri(:,[i,j]),tmp,[nf,nf])');
    end
  end
  
  clear Tmp1 Tmp2;  
  A=A+A'+Diag;

endfunction

