// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function M = Id(u,opt)
    [lhs,rhs]=argn(0);
    if rhs==1
      execstr('M = Id_'+typeof(u)+'(u)')
    else
      execstr('M = Id_'+typeof(u)+'(u,opt)')
    end
endfunction
