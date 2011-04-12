// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function y=y_grid2d_Node(g)
//tableau des ordonnées des noeuds de g
  [nx,ny]=size(g);
  y=matrix(g.y(:,ones(nx,1))',-1,1);
endfunction
