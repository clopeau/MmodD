// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_2d_acosh(%in1)
     %in1.Cell=acosh(%in1.Cell);
     %in1.#=rand(1);
     %in1.Id="acosh("+%in1.Id+")";
endfunction
   
