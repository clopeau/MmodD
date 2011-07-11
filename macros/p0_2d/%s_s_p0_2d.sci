// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%s_s_p0_2d(%s,%in1)
     %in1.Cell=%s-%in1.Cell;
     %in1.#=rand(1);
     %in1.Id=subf(string(%s),%in1.Id);
endfunction
   
