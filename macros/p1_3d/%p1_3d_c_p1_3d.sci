// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  %a=%p1_3d_c_p1_3d(%a,%b)
     // [a;b]
     %a.Node=[%a.Node,%b.Node];
     %a.#=rand();
     %a.Id=[%a.Id,%b.Id]
endfunction
   
