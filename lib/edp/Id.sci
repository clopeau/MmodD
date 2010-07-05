function M = Id(u,opt)
    [lhs,rhs]=argn(0);
    if rhs==1
      execstr('M = Id_'+typeof(u)+'(u)')
    else
      execstr('M = Id_'+typeof(u)+'(u,opt)')
    end
endfunction
