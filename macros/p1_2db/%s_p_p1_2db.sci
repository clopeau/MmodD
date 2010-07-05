function %in1=%s_p_p1_2db(%s,%in1)
    %in1.Node=%s .^ %in1.Node;
    %in1.Cell=%s .^ %in1.Cell;    
    %in1.#=rand(1);
endfunction
