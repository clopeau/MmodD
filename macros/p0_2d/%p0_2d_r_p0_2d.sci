// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_2d_r_p0_2d(%in1,%in2)
     %in1.Cell=%in1.Cell./%in2.Cell;
     %in1.#=rand(1);
     ierr=execstr('%in1.Id=rdivf(%in1.Id,%in2.Id)','errcatch');
     if ierr>0
       ierr=execstr('%in1.Id=%in1.Id+''/''+%in2.Id','errcatch');
     end
endfunction
   
