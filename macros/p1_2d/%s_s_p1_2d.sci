// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%s_s_p1_2d(%s,%in1)
     %in1.Node=%s-%in1.Node;
     %in1.#=rand(1);
     ierr=execstr('%in1.Id=subf(string(%s),%in1.Id)','errcatch');
     if ierr>0
       ierr=execstr('%in1.Id=string(%s)+''-''+%in1.Id','errcatch');
     end
endfunction
   
