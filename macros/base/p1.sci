// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=p1(%g,%fonc)
// construction d'une grille reguliere
// x,y [z] tableaux de points (ordre croissants)
// ou
// x,y z nombres de points en x,y,z

  [lhs,rhs]=argn(0);
  geo1d=['grid1d' 'line2d' 'line3d']
  geo2d=['tri2d' 'tri3d'];
  geo3d=['tet3d'];
  
  if grep(geo1d,typeof(%g))~=[]
    if rhs==1
      out=p1_1d(%g);
    else
      out=p1_1d(%g,%fonc)
    end    
  elseif  grep(geo2d,typeof(%g))~=[]
    if rhs==1
      out=p1_2d(%g);
    else
      out=p1_2d(%g,%fonc)
    end
  elseif  grep(geo3d,typeof(%g))~=[]
    if rhs==1
      out=p1_3d(%g);
    else
      out=p1_3d(%g,%fonc)
    end
  else
    error('--- unknow type of geometry !!! ----')
  end
endfunction

