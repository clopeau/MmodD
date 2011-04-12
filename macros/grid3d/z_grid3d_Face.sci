// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [z]=z_grid3d_Face(g)
//Extraction des coordonnées suivant l'axe des x d'une face de la grille 
//(Interpolation sur les faces)
 [nx,ny,nz]=size(g);
 ens=matrix(1:size(g,'f'),-1,1);
 if length(g.z)==1
   barz=g.z;
   z==matrix(g.z(:,ones(1:(nx-1)*(ny-1)))',-1,1);
   return
 else
   barz=(g.z(1:$-1)+g.z(2:$))/2;
 end
 
 z1=matrix(barz(:,ones(1:ny-1))',-1,1);
 z1=matrix(z1(:,ones(1:nx)),-1,1)
 z2=matrix(barz(:,ones(1:nx-1))',-1,1);
 z2=matrix(z2(:,ones(1:ny)),-1,1)
 z=[z1;z2;matrix(g.z(:,ones(1:(nx-1)*(ny-1)))',-1,1)];
endfunction
