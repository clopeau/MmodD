// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_3d_a_p1_3d(%in1,%in2)
     %in1.Node=%in1.Node+%in2.Node;
     %in1.#=rand(1);
endfunction
   
