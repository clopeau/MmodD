// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_3d_sign(%in1)
     %in1.Cell=sign(%in1.Cell);
     %in1.#=rand(1);
     %in1.Id="sign("+%in1.Id+")";
endfunction
   
