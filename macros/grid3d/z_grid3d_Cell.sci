// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [z]=z_grid3d_Cell(g)
//Extraction des coordonnées suivant l'axe des x d'une cellule de la grille 
//(Interpolation sur les faces)
  [nx,ny,nz]=size(g);
  barz=(g.z(1:$-1)+g.z(2:$))/2;
  z=matrix(barz(:,ones((nx-1)*(ny-1),1))',-1,1);
endfunction
