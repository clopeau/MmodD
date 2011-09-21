// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=upDy(v,u)
   execstr('out=Dyupw_'+typeof(u)+'(v,u)');
endfunction
 