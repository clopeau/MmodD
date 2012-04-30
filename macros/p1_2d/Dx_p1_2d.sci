// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 
function A=Dx_p1_2d(%u)
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  index=[2 3; 3 1; 1 2]';
  //-------------- Assemblage -------------------------------------------------
  A=spzeros(nf,nf);
  for i=1:3
    // init fct de base i
    execstr('tmp='+%th+'.Shape_p1_Grad(i)(:,1)');
    tmp=tmp/6;
 
    for j=1:3
      execstr('A=A+fastsparse('+%th+'.Tri(:,[i,j]),tmp,[nf,nf])');
    end
  end

endfunction

