function out=df(%g,%fonc)
// construction d'une grille reguliere
// x,y [z] tableaux de points (ordre croissants)
// ou
// x,y z nombres de points en x,y,z

  [lhs,rhs]=argn(0);
  if typeof(%g)=='grid2d'
    if rhs==1
      out=df2d(%g);
    else
      out=df2d(%g,%fonc)
    end
  elseif   typeof(%g)=='grid3d'
    if rhs==1
      out=df3d(%g);
    else
      out=df3d(%g,%fonc)
    end
  else
    error('The geometry must be a grid for df !!')
  end
endfunction

