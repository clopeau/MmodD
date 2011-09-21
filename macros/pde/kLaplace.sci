// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = kLaplace(%kk,%u)
  execstr('A = kLaplace_'+typeof(%u)+'(%kk,%u)');
//A = evstr('Laplace_'+typeof(u));
//execstr('Laplace_'+typeof(u));
endfunction
