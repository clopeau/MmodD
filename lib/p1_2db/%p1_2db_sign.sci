function %in1=%p1_2db_sign(%in1)
     %in1.Node=sign(%in1.Node);
     %in1.Cell=sign(%in1.Cell);     
     %in1.#=rand(1);
endfunction
   
