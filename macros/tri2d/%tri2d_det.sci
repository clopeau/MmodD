// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  Det=%tri2d_det(%th)
  // Calcul du determinant des simplex 2d
  // Det=2|T| : |T| aire du triangle
  [n,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  
  Det=zeros(nt,1);
  tmp=zeros(nt,1);
  for i=1:3
    tmp=%th.Coor(%th.Tri(:,index(1,i)),2)- %th.Coor(%th.Tri(:,index(2,i)),2);
    Det=Det+%th.Coor(%th.Tri(:,i),1).*tmp;
  end

endfunction

