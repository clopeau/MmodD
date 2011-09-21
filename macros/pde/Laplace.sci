// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = Laplace(u)
execstr('A = Laplace_'+typeof(u)+'(u)');
//A = evstr('Laplace_'+typeof(u));
//execstr('Laplace_'+typeof(u));
endfunction