// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_2d_log(%in1)
     %in1.Node=log(%in1.Node);
     %in1.#=rand(1);
     %in1.Id="log("+%in1.Id+")";
endfunction
   
