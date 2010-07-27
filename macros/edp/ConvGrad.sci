// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = ConvGrad(%u,%c)
  execstr('A = ConvGrad_'+typeof(%u)+'_'+typeof(%c)+'(%u,%c)');
endfunction
