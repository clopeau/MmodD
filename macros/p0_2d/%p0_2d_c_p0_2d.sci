// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  %a=%p0_2d_c_p0_2d(%a,%b)
     // [a;b]
     %a.Cell=[%a.Cell,%b.Cell];
     %a.#=rand();
     %a.Id=[%a.Id,%b.Id]
endfunction
   
