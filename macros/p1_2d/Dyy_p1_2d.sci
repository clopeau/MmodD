// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Dyy_p1_2d(%u)
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  //------------- Calcul du déterminant ---------------------------------------
  execstr('invdet=(-1/2) ./'+%th+'.Det')
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,1); // 1 ere fct de base
  Tmp2=zeros(nt,1); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,nf);
  
  if %u.domain==[]
    for i=1:3
      // init fct de base i
      execstr('Tmp1='+%th+'.Shape_p1_Grad(i)(:,2)');
      // Assemblage termes diagonal
      tmp=Tmp1.*Tmp1 .*invdet;
      
      execstr('Diag=Diag+fastsparse('+%th+'.Tri(:,[i i]),tmp,[nf,nf])');
      //
      for j=i+1:3
	// init fonct de base j
	execstr('Tmp2='+%th+'.Shape_p1_Grad(j)(:,2)');
	
	tmp= Tmp1.*Tmp2  .*invdet;
	
	execstr('A=A+fastsparse('+%th+'.Tri(:,[i,j]),tmp,[nf,nf])');
      end
    end
    
    A=A+A'+Diag;
  else
    for i=1:3
      // init fct de base i
      execstr('Tmp1='+%th+'.Shape_p1_Grad(i)(%u.BoolTri,2)');
      // Assemblage termes diagonal
      tmp=Tmp1.*Tmp1 .*invdet;
      
      execstr('Diag=Diag+fastsparse('+%th+'.Tri(%u.BoolTri,[i i]),tmp,[nf,nf])');
      //
      for j=i+1:3
	// init fonct de base j
	execstr('Tmp2='+%th+'.Shape_p1_Grad(j)(%u.BoolTri,2)');
	
	tmp= Tmp1.*Tmp2  .*invdet;
	
	execstr('A=A+fastsparse('+%th+'.Tri(%u.BoolTri,[i,j]),tmp,[nf,nf])');
      end
    end
    
    A=A+A'+Diag;
    A=A(%u.BoolNode,%u.BoolNode);
  end
endfunction

