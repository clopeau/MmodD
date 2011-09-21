// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = ConvDy(%u,%c)
  execstr('A = ConvDy_'+typeof(%u)+'_'+typeof(%c)+'(%u,%c)');
endfunction
