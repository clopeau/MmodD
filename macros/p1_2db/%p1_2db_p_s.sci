function %in1=%p1_2db_p_s(%in1,%s)
    %in1.Node=%in1.Node .^ %s;
    %in1.Cell=%in1.Cell .^ %s;    
    %in1.#=rand(1);
endfunction
  
