function %in1=%p1_2db_tanh(%in1)
     %in1.Node=tanh(%in1.Node);
     %in1.Cell=tanh(%in1.Cell);     
     %in1.#=rand(1);
endfunction
   
