// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [y]=y_grid2d_Cell(g)
//Extraction des coordonnées suivant l'axe des x d'une cellule de la grille 
//(Interpolation sur les faces)
  [nx,ny]=size(g);
  bary=(g.y(1:$-1)+g.y(2:$))/2;
  y=matrix(bary(:,ones(nx-1,1))',-1,1);
endfunction
