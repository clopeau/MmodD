// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_2d_asinh(%in1)
     %in1.Node=asinh(%in1.Node);
     %in1.#=rand(1);
     %in1.Id="asinh("+%in1.Id+")";
endfunction
   
