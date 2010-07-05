function [ploc,vloc]=lsolve_darcy(pb,opt)
    [lhs,rhs]=argn(0);

    if rhs==2
      execstr('[ploc,vloc]=lsolve_darcy_'+typeof(evstr(pb.pression))+'(pb,opt)');
    else
      execstr('[ploc,vloc]=lsolve_darcy_'+typeof(evstr(pb.pression))+'(pb)');
    end
endfunction
  
