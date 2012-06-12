// Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = Dxz(u)
  execstr('A = Dxz_'+typeof(u)+'(u)');
endfunction
