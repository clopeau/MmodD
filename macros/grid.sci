function out=grid(x,y,z)
// construction d'une grille reguliere
// x,y [z] tableaux de points (ordre croissants)
// ou
// x,y z nombres de points en x,y,z

  [lhs,rhs]=argn(0);
  if rhs==2
    out=grid2d(x,y);
  else 
    out=grid3d(x,y,z);
  end
  
endfunction

