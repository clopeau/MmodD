// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 


function uloc=lsolve_edp(%pb,%opt)
    [lhs,rhs]=argn();
    
    if rhs==2
      execstr('[uloc]=lsolve_edp_'+typeof(evstr(%pb.var))+'(%pb,%opt)');
    else
      execstr('[uloc]=lsolve_edp_'+typeof(evstr(%pb.var))+'(%pb)');
    end   
endfunction
