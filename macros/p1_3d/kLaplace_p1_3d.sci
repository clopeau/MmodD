// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=kLaplace_p1_3d(%kk,%u)
  if typeof(%kk)=='p1_3d'
      %kk=p0(%kk)
  end
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  index=[2 3; 3 1; 1 2]';
  lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
  //------------- Calcul du déterminant ---------------------------------------
  execstr('invdet=(-1/6)./det('+%th+')');
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,3); // 1 ere fct de base
  Tmp2=zeros(nt,3); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,1);
  
  for i=1:4
    
    execstr('Tmp1='+%th+'.Shape_p1_Grad(i)');

    tmp=sum(Tmp1.^2,'c') .*invdet .*%kk.Cell;
    
    execstr('Diag=Diag+fastsparse(['+%th+'.Tet(:,i),ones(nt,1)],tmp,[nf,1])');

    //
    for j=i+1:4
      // init fonct de base j
      execstr('Tmp2='+%th+'.Shape_p1_Grad(j)');
      
      tmp=sum(Tmp1.*Tmp2,'c') .*invdet .*%kk.Cell;
      
      execstr('A=A+fastsparse(' + %th + '.Tet(:,[i,j]),tmp,[nf,nf])');     

    end
  end
  
  clear Tmp1 Tmp2;  
  A=A+A'+diag(Diag);

endfunction

