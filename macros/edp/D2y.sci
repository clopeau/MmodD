// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = D2y(u)
  execstr('A = D2y_'+typeof(u)+'(u)');
endfunction
