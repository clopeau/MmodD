// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_2d_coth(%in1)
     %in1.Node=coth(%in1.Node);
     %in1.#=rand(1);
     %in1.Id="coth("+%in1.Id+")";
endfunction
   
