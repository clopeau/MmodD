// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_3d_s_p1_3d(%in1,%in2)
     %in1.Node=%in1.Node-%in2.Node;
     %in1.#=rand(1);
     ierr=execstr('%in1.Id=subf(%in1.Id,%in2.Id)','errcatch');
     if ierr>0
       ierr=execstr('%in1.Id=%in1.Id+''-''+%in2.Id','errcatch');
     end
endfunction
   
