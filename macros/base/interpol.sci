// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function interpol(%u,%fonction)
   %nomvar=name(%u);
   if type(%fonction)==10
      %fonction=matrix( %fonction,-1,1);
     %fonction=strsubst(%fonction,' ','')
   end
   
   %u=evstr('interpol_'+typeof(%u)+'(%u,'''+%fonction+''')')
   //execstr('interpol_'+typeof(%u)+'('+name(%u)+','''+%fonction+''')');
   execstr('['+%nomvar+']=return(%u);');
endfunction
 
