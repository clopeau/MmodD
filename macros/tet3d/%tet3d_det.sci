// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  Det=%tet3d_det(th)
  // Calcul du determinant des simplex 3d
  // Det=2|T| : |T| aire du triangle
  [n,nt]=size(th);
  lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);

  //lindex=list([1 2 3],[1 2 4],[1 3 4],[2 3 4]);
  // init espace
  Det=zeros(nt,1);
  for i=1:4
    tmp=((-1)^(i))*det2d(th.Coor,th.Tet(:,lindex(i)));
    Det=Det+tmp.*th.Coor(th.Tet(:,i),3);
  end
endfunction

