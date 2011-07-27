// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_2d_r_s(%in1,%s)
     %in1.Cell= %in1.Cell ./%s;
     %in1.#=rand(1);
     ierr=execstr('%in1.Id=rdivf(%in1.Id,string(%s))','errcatch');
     if ierr>0
       ierr=execstr('%in1.Id=%in1.Id+''/''+string(%s)','errcatch');
     end
endfunction
   
