function [x]=x_grid1d_Cell(g)
//Extraction des coordonnées suivant l'axe des x d'une cellule de la grille 
//(Interpolation sur les faces)
  x=(g.x(1:$-1)+g.x(2:$))/2;
endfunction
