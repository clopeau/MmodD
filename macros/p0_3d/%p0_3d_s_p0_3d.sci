// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_3d_s_p0_3d(%in1,%in2)
     %in1.Cell=%in1.Cell-%in2.Cell;
     %in1.#=rand(1);
     %in1.Id=subf(%in1.Id,%in2.Id);
endfunction
   
