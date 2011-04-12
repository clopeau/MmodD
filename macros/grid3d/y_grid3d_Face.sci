// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [y]=y_grid3d_Face(g)
//Extraction des coordonnées suivant l'axe des x d'une face de la grille 
//(Interpolation sur les faces)
 [nx,ny,nz]=size(g);
 if length(g.y)==1
   bary=g.y;
   y=matrix(g.y(:,ones(1:(nz-1)*(nx-1)))',-1,1);
   return
 else
   bary=(g.y(1:$-1)+g.y(2:$))/2;
 end
 Y=matrix(g.y(:,ones(1:(nz-1)*(nx-1)))',-1,1);
 bary1=matrix(bary(:,ones(1:(nx*(nz-1)))),-1,1);
 bary2=matrix(bary(:,ones(1:(nx-1)))',-1,1);
 bary2=matrix(bary2(:,ones(1:nz)),-1,1);
 y=[bary1;Y;bary2];
endfunction
