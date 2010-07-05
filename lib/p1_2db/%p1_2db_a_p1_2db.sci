function %in1=%p1_2db_a_p1_2db(%in1,%in2)
     %in1.Node=%in1.Node+%in2.Node;
     %in1.Cell=%in1.Cell+%in2.Cell;
     %in1.#=rand(1);
endfunction
   
