// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_3d_log2(%in1)
     %in1.Cell=log2(%in1.Cell);
     %in1.#=rand(1);
     %in1.Id="log2("+%in1.Id+")";
endfunction
   
