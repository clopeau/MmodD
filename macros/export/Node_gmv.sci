// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function Node_gmv(u,%v)
  nomvar=strsubst(%v.Id,' ','')
  if nomvar==''
    nomvar=name_mmodd(%v);
  end
  [a,ierr]=evstr(nomvar);
  if nomvar==''|ierr==0
    nomvar='scalaire';
  end
  nomvar=strsubst(nomvar,'%','')
  
  mfprintf(u,nomvar+' 1\n');
  mfprintf(u,"%f\n",%v.Node);
endfunction
  
