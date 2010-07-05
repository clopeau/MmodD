function [x]=x_grid2d_Face(g)
//Extraction des coordonnées suivant l'axe des x d'une face de la grille 
//(Interpolation sur les faces)
 [nx,ny]=size(g);
 barx=(g.x(1:$-1)+g.x(2:$))/2;
 X=matrix(g.x(:,ones(1:(ny-1)))',-1,1);
 barx=matrix(barx(:,ones(1:ny)),-1,1);
 x=[X;barx];
endfunction
