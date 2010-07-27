// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out = Grad(%u)

  execstr('%out = Grad_'+typeof(%u)+'(%u)');

endfunction
