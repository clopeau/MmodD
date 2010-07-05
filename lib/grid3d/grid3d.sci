function out=grid3d(x,y,z)
// construction d'une grille reguliere
// x,y [z] tableaux de points (ordre croissants)
// ou
// x,y z nombres de points en x,y,z

  [lhs,rhs]=argn(0);
  if typeof(x)=='grid3d'
    out=export_grid3d(x,y)
    return
  end
  
  // carre unite par defaut
  if length(x)==1&length(y)==1&length(z)==1
    x=linspace(0,1,x)';
    y=linspace(0,1,y)';
    z=linspace(0,1,z)';
   end
  
  // suivant nombre d'argument et mise en colonne
  x=matrix(x,-1,1);
  y=matrix(y,-1,1);
  z=matrix(z,-1,1);
  id='grid3d'
  BndId=['S','E','N','W','D','U'];
  out=mlist(['grid3d';'#';'id';'BndId';'x';'y';'z'],rand(),id,BndId,x,y,z)
    
endfunction

