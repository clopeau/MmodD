// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_2d_atan(%in1,%in2)
     [lhs,rhs]=argn(0);
     if rhs==1
       %in1.Node=atan(%in1.Node);
       %in1.#=rand(1);
       %in1.Id="atan("+%in1.Id+")";
     else
       %in1.Node=atan(%in1.Node,%in2.Node);
       %in1.#=rand(1);
       %in1.Id="atan("+%in1.Id+","+%in2.Id+")";
     end
endfunction
   
