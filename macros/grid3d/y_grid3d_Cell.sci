// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [y]=y_grid3d_Cell(g)
//Extraction des coordonnées suivant l'axe des x d'une cellule de la grille 
//(Interpolation sur les faces)
  [nx,ny,nz]=size(g);
  bary=(g.y(1:$-1)+g.y(2:$))/2;
  y=matrix(bary(:,ones(nx-1,1))',-1,1)
  y=matrix(y(:,ones(nz-1,1)),-1,1)
endfunction
