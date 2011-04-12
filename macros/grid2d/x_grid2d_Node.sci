// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function x=x_grid2d_Node(g)
//tableau des abcisses des noeuds de g
  [nx,ny]=size(g);
  x=matrix(g.x(:,ones(ny,1)),-1,1);
endfunction
