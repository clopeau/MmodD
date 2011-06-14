// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=tcube3d(x,y,z)
// Creation d'un maillage grille sur un cube
// syntaxe :
// --------
//
//  tcube3d()      : carre unité a deux triangles
//
//  tcube3d(nx,ny,nz) : grille unité a 5*nx*ny*nz triangles
//
//  tcube3d(x,y,z)   : x,y et z vecteurs d'affixes et d'ordonnes
//

  th=tet3d('cube3d');
  
  g=grid3d(x,y,z);
  [nx,ny,nz]=size(g);
  x=matrix(g.x(:,ones(nz*ny,1)),-1,1);
  y=matrix(g.y(:,ones(nx,1))',-1,1);
  y=matrix(y(:,ones(nz,1)),-1,1);
  z=matrix(g.z(:,ones(nx*ny,1))',-1,1);
  th.Coor=[x y z];
  clear x y z
  
  Base= [1 1 1 1 2 2 2 2;
      1 1 2 2 1 1 2 2;
      1 2 1 2 1 2 1 2]';
  indice6=[1 2 6 8;
          1 2 8 4;
          1 4 8 3;
          1 6 5 8;
          1 7 8 5;
          1 3 8 7];

  //indice5=[5 1 6 7; 3 4 1 7; 2 6 1 4; 8 6 4 7; 1 7 4 6];
  
  nn=(nx-1)*(ny-1)*(nz-1);
  th.Tet=zeros(5*nn,4);
  
  for i=1:6
    for j=1:4
      th.Tet(1+(i-1)*nn:i*nn,j)=g(Base(indice6(i,j),:),'c2n')
    end
  end
  
  
  //------  point frontiere -------
  th.BndId=['E','W','N','S','U','D'];
  // Face Est West
  Base=[1 2 3; 2 3 4; 1 2 4;1 3 4]
  
  for face=1:6
    ind=g(th.BndId(face))
    b=~ones(size(th),1);
    b(ind)=%T;  
    B=matrix(b(th.Tet),-1,4)
    th.Bnd(face)=[];
    for i=1:4
      ii=find(B(:,Base(i,1))==%t&B(:,Base(i,2))==%t&B(:,Base(i,3))==%t);
      th.Bnd(face)=[th.Bnd(face); th.Tet(ii,Base(i,:))]
    end
  end 
  
 // Faces orientation
  for i=[1 2 3 5 6]
    th.Bnd(i)=th.Bnd(i)(:,[2 1 3]);
  end
  
  th.TetId=ones(size(th.Tet,1),1);
endfunction
 
