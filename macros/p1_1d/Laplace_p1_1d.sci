// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Laplace_p1_1d(%u)
    %th=evstr(%u.geo);
    nx=size(%th);
    h=%th.x(2:$)-%th.x(1:$-1);
     
    A=spzeros(nx,nx);
    for i=0:1
      for j=0:1
	A=A-sparse([(1:nx-1)+i;(1:nx-1)+j]',(-1)^i * (-1)^j ./h,[nx,nx]);
      end
    end
    
endfunction
  
