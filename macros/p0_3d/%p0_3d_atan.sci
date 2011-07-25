// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p0_3d_atan(%in1)
     [lhs,rhs]=argn(0);
     if rhs==1
       %in1.Cell=atan(%in1.Cell);
       %in1.#=rand(1);
       %in1.Id="atan("+%in1.Id+")";
     else
       %in1.Cell=atan(%in1.Cell,%in2.Cell);
       %in1.#=rand(1);
       %in1.Id="atan("+%in1.Id+","+%in2.Id+")";
     end      %in1.Cell=atan(%in1.Cell);
endfunction
   
