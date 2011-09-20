// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function VCell_vtk(%u,%v)
  [%n,%dim]=size(%v)
  if typeof(%v)=='p1nc3d'
    %v=p0(%v)
  end
  %ttype=typeof(%v);
  %nomvar=name_mmodd(%v);
  if length(%nomvar)==0
    %nomvar='Vector_'+part(string(rand(1)*1000000),1:3);
  end
  %nomvar=strsubst(%nomvar,'%','')
  fprintf(%u,'VECTORS '+%nomvar+' float');
  
   //--- ecriture suivant taille ------
  Var2dCell=['p0_2d']
  Var3dCell=['p0_3d' 'p0_2d']
  if grep(Var2dCell,%ttype)~=[]&(%dim==2)
    fprintf(%u,"%g %g 0.\n ",%v.Cell);
  elseif grep(Var3dCell,%ttype)~=[]&(%dim==3)
    fprintf(%u,"%g %g %g\n ",%v.Cell);
  else
    error("exportVTK: The variable "+%nomvar+" must have 2 or 3 components")
  end

endfunction
  
