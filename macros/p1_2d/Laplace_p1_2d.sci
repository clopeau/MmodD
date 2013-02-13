// Copyright (C) 2010 - Thierry Clopeau
// Copyright (C) 2013 - Gilquin Laurent
// Copyright (C) 2013 - Lefebvre Augustin
// Copyright (C) 2013 - Janczarski Stéphane
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//  
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Laplace_p1_2d(%u)
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  //------------- Calcul du determinant ---------------------------------------
  execstr('invdet=(-1/2) ./'+%th+'.Det')
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,2); // 1 ere fct de base
  Tmp2=zeros(nt,2); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,nf);
  
  if %u.domain==[]
    for i=1:3
      // init fct de base i
      execstr('Tmp1='+%th+'.Shape_p1_Grad(i)');
      // Assemblage termes diagonal
      tmp=((Tmp1.*Tmp1)*[ones(1,size(Tmp1,2))'])  .*invdet;
      execstr('Diag=Diag+fastsparse('+%th+'.Tri(:,[i i]),tmp,[nf,nf])');
      //
      for j=i+1:3
        // init fonct de base j
	execstr('Tmp2='+%th+'.Shape_p1_Grad(j)');
    
	tmp=((Tmp1.*Tmp2)*[ones(1,size(Tmp1,2))']) .*invdet;
    
	execstr('A=A+fastsparse('+%th+'.Tri(:,[i,j]),tmp,[nf,nf])');
      end
    end
    
    A=A+A'+Diag;
  else
    invdet=invdet(%u.BoolTri)
    for i=1:3
      // init fct de base i
      execstr('Tmp1='+%th+'.Shape_p1_Grad(i)(%u.BoolTri,:)');
      // Assemblage termes diagonal
      tmp=((Tmp1.*Tmp1)*[ones(1,size(Tmp1,2))'])  .*invdet;
      execstr('Diag=Diag+fastsparse('+%th+'.Tri(%u.BoolTri,[i i]),tmp,[nf,nf])');
      //
      for j=i+1:3
         // init fonct de base j
	execstr('Tmp2='+%th+'.Shape_p1_Grad(j)(%u.BoolTri,:)');
    
	tmp=((Tmp1.*Tmp2)*[ones(1,size(Tmp1,2))']) .*invdet;
    
	execstr('A=A+fastsparse('+%th+'.Tri(%u.BoolTri,[i,j]),tmp,[nf,nf])');
      end
    end
    
    A=A+A'+Diag;
    A=A(%u.BoolNode,%u.BoolNode);
  end
endfunction


