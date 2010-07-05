function th=hcube3d(x,y,z)
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

  th=hex3d('cube3d');
  
  g=grid3d(x,y,z);
  [nx,ny,nz]=size(g);
  x=matrix(g.x(:,ones(nz*ny,1)),-1,1);
  y=matrix(g.y(:,ones(nx,1))',-1,1);
  y=matrix(y(:,ones(nz,1)),-1,1);
  z=matrix(g.z(:,ones(nx*ny,1))',-1,1);
  
  th.Coor=[x y z];
  clear x y z
  Base= [1 2 2 1 1 2 2 1;
      1 1 2 2 1 1 2 2;
      1 1 1 1 2 2 2 2]';

  nn=(nx-1)*(ny-1)*(nz-1);
  th.Hex=zeros(nn,8);
  
  for i=1:8
    th.Hex(:,i)=g(Base(i,:),'c2n')
  end
  
  
endfunction
 
