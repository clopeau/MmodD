// Copyright (C) 2010-12 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=p1(%g,%fonc,%domain)

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
      [out,%g]=p1_2d(%g);
    elseif rhs==2 & exists('domain','local')
      [out,%g]=p1_2d(%g,domain=domain)
    elseif rhs==2
      [out,%g]=p1_2d(%g,%fonc)
    else
      [out,%g]=p1_2d(%g,%fonc,domain=domain)
    end
    execstr('['+name_mmodd(%g)+']=return(%g);');
  elseif  grep(geo3d,typeof(%g))~=[]
    if rhs==1
      [out,%g]=p1_3d(%g);
    elseif rhs==2 & exists('domain','local')
      [out,%g]=p1_3d(%g,domain=domain)
    elseif rhs==2
      [out,%g]=p1_3d(%g,%fonc)
    else
      [out,%g]=p1_3d(%g,%fonc,domain=domain)
    end
    execstr('['+name_mmodd(%g)+']=return(%g);');
  else
    error('--- unknow type of geometry !!! ----')
  end
  
endfunction

