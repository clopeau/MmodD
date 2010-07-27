// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %_nams=name(%in)
   %_nams=who('get');
   //%_nams=%_nams(%_vol>17);
   global %exclud
   %_nams(grep(%_nams,%exclud))=[]
   %_bool=~zeros(%_nams);
   %_sel=typeof(%in)
   for %_k=1:size(%_nams,1)
     execstr('%_typn=typeof('+%_nams(%_k)+')');
     %_bool(%_k)=(%_typn==%_sel);
   end
   //execstr('%_bool=typeof('+%_nams+')==%_sel')
   //%_typeof=evstr('typeof('+%_nams+')')
   //%_nams=%_nams(%_typeof==typeof(%in));
   %_nams=%_nams(%_bool)
   //%_nams=%_nams(%_nams~='%in');
   if %_nams==[]
      %_nams="toto"
   else
      %_nams=%_nams(evstr(%_nams+'.#==%in.#'));
      %_nams=%_nams(1);
   end
   if %_nams==""
     %_nams="toto"
   end
 endfunction
 
   
