function out=q1(%g,%fonc)
// construction d'une grille reguliere
// x,y [z] tableaux de points (ordre croissants)
// ou
// x,y z nombres de points en x,y,z

  [lhs,rhs]=argn(0);
  geo2d=['grid2d' 'quad2d' 'quad3d'];
  geo3d=['grid3d' 'hex3d'];
  
  select typeof(%g)
  case 'grid2d'
    if rhs==1
      out=q1p2d(%g);
    else
      out=q1p2d(%g,%fonc)
    end
  case 'quad2d'
    if rhs==1
      out=q1_2d(%g);
    else
      out=q1_2d(%g,%fonc)
    end
  case 'quad3d'
    if rhs==1
      out=q1_2d(%g);
    else
      out=q1_2d(%g,%fonc)
    end
  case 'grid3d'
    if rhs==1
      out=q1p3d(%g);
    else
      out=q1p3d(%g,%fonc)
    end
  case 'hex3d'
    if rhs==1
      out=q1_3d(%g);
    else
      out=q1_3d(%g,%fonc)
    end    
  else
    error('--- unknow type of geometry !!! ----')
  end
endfunction

