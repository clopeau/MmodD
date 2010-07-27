// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=tsquare2d(x,y,nx,ny)
// Creation d'un maillage grille sur un carre
// syntaxe :
// --------
//
//  square2d()      : carre unité a deux triangles
//
//  square2d(nx,ny) : grille unité a 2*nx*ny triangles
//
//  square2d(x,y)   : x et y vecteurs d'affixes et d'ordonnes
//
//  square2d([x_min,x_max],[y_min,y_max],nx,ny)   
//
// Le resultat possede 4 frontieres 'E' 'W' 'N' 'S'
  [lhs,rhs]=argn(0);
  if rhs==0                     // carre unite 4 nodes 2 triangles
    x=[0;1];nx=2;
    y=[0,1];ny=2;
  elseif rhs==2 
    if length(x)==1 & length(y)==1 // carre unite de nx,ny points par ligne 
      nx=x;
      ny=y;
      x=linspace(0,1,nx)';
      y=linspace(0,1,ny)';
    elseif length(x)>1 & length(y)>1
      nx=length(x);x=matrix(x,-1,1);
      ny=length(y);y=matrix(y,-1,1);
    else
      error('Bad arguments in square function');
      return
    end
  elseif rhs==4&length(x)==2&length(y)==2&length(nx)==1&length(ny)==1
    x=linspace(x(1),x(2),nx)';
    y=linspace(y(1),y(2),ny)';
  else
    error('Bad arguments in square function');
    return
  end
  
   th=tri2d("square2d");
   //-------
   // Coor
   //-------
   th.Coor=[matrix(x(:,ones(y)),-1,1),matrix(y(:,ones(x))',-1,1)];
   //-------
   //  Tri
   //-------
   // parcours par ligne
   // premiers triangles
   tmp=ones((nx-1)*(ny-1),3);
   tmp(nx:nx-1:$,:)=2;
   tmp(1,2)=2; tmp(1,3)=nx+1;
   th.Tri=cumsum(tmp,'r');
   // seconds triangles
   tmp=ones((nx-1)*(ny-1),3);
   tmp(nx:nx-1:$,:)=2;
   tmp(1,1)=2; tmp(1,2)=nx+2; tmp(1,3)=nx+1;
   th.Tri=[th.Tri ; cumsum(tmp,'r')]
   // Modifications des angles
   if nx>2 & ny >2
     th.Tri(1,:)=[1 2 nx+2];
     th.Tri((nx-1)*(ny-1)+1,:)=[1 nx+2 nx+1];
     th.Tri($,:)=[nx*ny nx*ny-1 nx*(ny-1)-1];
     th.Tri($-(nx-1)*(ny-1),:)=[nx*ny nx*(ny-1)-1 nx*(ny-1)];
   end
   // Reordonnancement des triangles 
   [tmp,i]=lex_sort(th.Tri); clear tmp;
   th.Tri=th.Tri(i,:);
   //-------
   //  BndId
   //------- 
   th.BndId=['W' 'E' 'N' 'S'];
   th.BndPerio=~ones(4,1);
   //-------
   //  BndId
   //------- 
   th.Bnd=list(...
       find(ones(1:ny).*.[1 zeros(1:nx-1)])',...
       find(ones(1:ny).*.[zeros(1:nx-1) 1])',...
       find([zeros(1:ny-1) 1].*.ones(1:nx))',...
       find([1 zeros(1:ny-1)].*.ones(1:nx))'...
       );
 
endfunction
 
