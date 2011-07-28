// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  %a=%p0_3d_c_p0_3d(%a,%b)
     // [a;b]
     %a.Cell=[%a.Cell,%b.Cell];
     %a.#=rand();
     %a.Id=[%a.Id,%b.Id]
endfunction
   
