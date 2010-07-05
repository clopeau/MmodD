function [x]=x_grid2d_Cell(g)
//Extraction des coordonnées suivant l'axe des x d'une cellule de la grille 
//(Interpolation sur les faces)
  [nx,ny]=size(g);
  barx=(g.x(1:$-1)+g.x(2:$))/2;
  x=matrix(barx(:,ones(1:ny-1)),-1,1);
endfunction
