// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function Node_vtk(%u,%v)
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
   mfprintf(%u,"LOOKUP_TABLE default\n")
   mfprintf(%u,"%g\n ",%v.Node);
endfunction
  
