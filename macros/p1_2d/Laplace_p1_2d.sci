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
  Diag=spzeros(nf,1);
  
  for i=1:3
    // init fct de base i
    execstr('Tmp1='+%th+'.Shape_p1_Grad(i)');
    // Assemblage termes diagonal
    tmp=sum(Tmp1.^2,'c') .*invdet;
    execstr('Diag=Diag+sparse(['+%th+'.Tri(:,i),ones(nt,1)],tmp,[nf,1])');
    //
    for j=i+1:3
      // init fonct de base j
      execstr('Tmp2='+%th+'.Shape_p1_Grad(j)');
      
      tmp=sum(Tmp1.*Tmp2,'c') .*invdet;
      
      execstr('A=A+sparse('+%th+'.Tri(:,[i,j]),tmp,[nf,nf])');
    end
  end
  
  clear Tmp1 Tmp2;  
  A=A+A'+diag(Diag);

endfunction

