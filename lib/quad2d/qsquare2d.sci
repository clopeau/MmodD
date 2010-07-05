function th=qsquare2d(x,y)
// Creation d'un maillage grille sur un carre
// syntaxe :
// --------
//
//  quad_square2d()      : carre unité a deux quadrangles
//
//  square2d(nx,ny) : grille unité a 2*nx*ny quadrangles
//
//  square2d(x,y)   : x et y vecteurs d'affixes et d'ordonnes

   g=grid2d(x,y)
   th=quad2d('square2d');
   th.Coor=[matrix(g.x(:,ones(g.y)),-1,1),...
       matrix(g.y(:,ones(g.x))',-1,1)];
   
   th.Quad=zeros(size(g,'c'),4);
   Angle=[1 2 2 1;1 1 2 2]';
   for i=1:4
     th.Quad(:,i)=g(Angle(i,:),'c2n');
   end
   
   th.BndId=['W' 'E' 'N' 'S'];
   th.BndPerio=~ones(4,1);
   //-------
   //  BndId
   //------- 
   th.Bnd=list()
   for front=th.BndId
     th.Bnd($+1)=g(front)
   end
    
endfunction
 
