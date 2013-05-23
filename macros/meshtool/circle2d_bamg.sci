// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=circle2d_bamg(R,n);
  
  [lhs,rhs]=argn(0);
  
  if rhs<=1
    n=8;
  end
  if rhs==0
    R=1
  end
  
  teta=linspace(0,2*%pi,n+1)';
  teta($)=[];
  th=tri2d('circle2d');
  th.Coor=R*[cos(teta),sin(teta)];
  th.Bnd=list([1:n 1]);
  th.BndPerio(1)=%t
  th=bamg(th);

endfunction
