// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function Cell_vtk(%u,%v)
  if typeof(%v)=='p1nc3d'
    %v=p0(%v)
  end
  %nomvar=name_mmodd(%v);
  if length(%nomvar)==0
    if length(%v.Id)==0
      %nomvar='mat'+part(string(rand(1)*1000000),1:3);
    else
      %nomvar=strsubst(%v.Id,' ','_')
    end
  end
  %nomvar=strsubst(%nomvar,'%','')
  
  mfprintf(%u,'SCALARS '+%nomvar+' float 1\n');
  mfprintf(%u,"LOOKUP_TABLE default\n");
  mfprintf(%u,"%g\n ",%v.Cell);

endfunction
  
