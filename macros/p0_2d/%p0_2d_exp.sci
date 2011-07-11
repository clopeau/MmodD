// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_2d_exp(%in1)
     %in1.Cell=exp(%in1.Cell);
     %in1.#=rand(1);
     %in1.Id="exp("+%in1.Id+")";
endfunction
   
