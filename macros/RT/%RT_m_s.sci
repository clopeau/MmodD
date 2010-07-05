function %in1=%RT_m_s(%in1,%s)
    %in1.Face=%in1.Face .* %s;
    %in1.#=rand(1);
endfunction
 
