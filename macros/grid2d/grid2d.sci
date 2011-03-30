function out=grid2d(x,y)
// construction d'une grille reguliere
// x,y  tableaux de points (ordre croissants)
// ou
// x,y nombres de points en x,y

  [lhs,rhs]=argn(0);
  // extraction de la grille frontière
  if typeof(x)=='grid2d'
    out=export_grid2d(x,y)
    return
  end
  
  // carre unite par defaut
  if length(x)==1&length(y)==1
    x=linspace(0,1,x)';
    y=linspace(0,1,y)';
  end
  
  // suivant nombre d'argument et mise en colonne
  x=matrix(x,-1,1);
  y=matrix(y,-1,1);
  id='grid2d'
  BndId=['S','E','N','W'];
  out=mlist(['grid2d';'#';'id';'BndId';'x';'y'],rand(),id,BndId,x,y)
    
endfunction

