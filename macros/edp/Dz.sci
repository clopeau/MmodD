// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = Dz(u,flag)
[lhs,rhs] = argn(0)
if (rhs == 1) then
  execstr('A = Dz_'+typeof(u)+'(u)');
else
  execstr('A = Dz_'+typeof(u)+'(u,flag)');
end
endfunction
