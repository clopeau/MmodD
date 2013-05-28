// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function mmodd_update()
   atomsSystemUpdate()
   res=atomsUpdate('MmodD')
   if res==[]
     write(%io(2),'MmodD Already up-to-date.')
   else
     disp(res)
   end
 endfunction
 
   
