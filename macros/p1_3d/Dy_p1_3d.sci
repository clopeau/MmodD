// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Dy_p1_3d(%u)
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
  //-------------- Assemblage -------------------------------------------------
  A=spzeros(nf,nf);

  for i=1:4
    // init fct de base i
    tmp=(-1)^(i+1) *det2d(%th.Coor(:,index(:,2)),%th.Tet(:,lindex(i)));
    tmp=tmp/24;
 
    for j=1:4
      A=A+sparse(%th.Tet(:,[i,j]),tmp,[nf,nf]);
    end
  end

endfunction

