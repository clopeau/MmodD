// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 


function uloc=lsolve_pde(%pb,%opt)
    [lhs,rhs]=argn();
    
    if rhs==2
      execstr('[uloc]=lsolve_pde_'+typeof(evstr(%pb.var))+'(%pb,%opt)');
    else
      execstr('[uloc]=lsolve_pde_'+typeof(evstr(%pb.var))+'(%pb)');
    end   
endfunction
