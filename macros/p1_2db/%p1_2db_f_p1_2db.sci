function  %a=%p1_2db_f_p1_2db(%a,%b)
     // [a;b]
     %a.Node=[%a.Node,%b.Node];
     %a.Cell=[%a.Cell,%b.Cell];
     %a.#=rand();
endfunction
