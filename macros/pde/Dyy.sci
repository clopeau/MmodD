// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = Dyy(u)
  execstr('A = Dyy_'+typeof(u)+'(u)');
endfunction
