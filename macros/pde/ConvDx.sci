// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A = ConvDx(%u,%c)
  execstr('A = ConvDx_'+typeof(%u)+'_'+typeof(%c)+'(%u,%c)');
endfunction
