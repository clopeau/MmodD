// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function x=x_grid3d_Face(g)
//Extraction des coordonnées suivant l'axe des x d'une face de la grille 
//(Interpolation sur les faces)
 [nx,ny,nz]=size(g);
 if length(g.x)==1
   barx=g.x;
   x=matrix(g.x(:,ones(1:(nz-1)*(ny-1)))',-1,1);
   return
 else
   barx=(g.x(1:$-1)+g.x(2:$))/2;
 end
 X=matrix(g.x(:,ones(1:(nz-1)*(ny-1)))',-1,1);
 barx=matrix(barx(:,ones(1:(ny*(nz-1)+nz*(ny-1)))),-1,1);
 x=[X;barx];
endfunction
