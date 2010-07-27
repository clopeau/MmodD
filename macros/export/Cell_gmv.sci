// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function Cell_gmv(u,%v)
  nomvar=strsubst(%v.Id,' ','')
  if nomvar==''
    nomvar=name(%v);
  end
  [a,ierr]=evstr(nomvar);
  if nomvar==''|ierr==0
    nomvar='scalaire';
  end
  nomvar=strsubst(nomvar,'%','')
  
  fprintf(u,nomvar+' 0');
  fprintf(u,"%f\n",%v.Cell);
endfunction
  