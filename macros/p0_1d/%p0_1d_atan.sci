function %in1=%p0_1d_atan(%in1)
     [lhs,rhs]=argn(0);
     if rhs==1
       %in1.Cell=atan(%in1.Cell);
       %in1.#=rand(1);
       %in1.Id="atan("+%in1.Id+")";
     else
       %in1.Cell=atan(%in1.Cell,%in2.Cell);
       %in1.#=rand(1);
       %in1.Id="atan("+%in1.Id+","+%in2.Id+")";
     end 
endfunction
   
