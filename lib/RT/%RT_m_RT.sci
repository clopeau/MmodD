function %in1=%RT_m_RT(%in1,%in2)
     %in1.Face=%in1.Face .* %in2.Face;
     %in1.#=rand();
endfunction
   
