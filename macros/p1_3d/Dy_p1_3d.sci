// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Dy_p1_3d(%u)
  %th=%u.geo;
  execstr('[nf,nt]=size('+%th+')');
  //-------------- Assemblage -------------------------------------------------
  A=spzeros(nf,nf);

  for i=1:4
    // init fct de base i
    execstr('tmp='+%th+'.Shape_p1_Grad(i)(:,2)');
    tmp=tmp/24;
 
    for j=1:4
      execstr('A=A+fastsparse('+%th+'.Tet(:,[i,j]),tmp,[nf,nf])');
    end
  end

endfunction

