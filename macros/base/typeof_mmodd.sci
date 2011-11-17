// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=typeof_mmodd(%in)
// faster than original typeof
// work only if type(%in)==17
   %out=getfield(1,%in);
   %out=%out(1);
endfunction
 
