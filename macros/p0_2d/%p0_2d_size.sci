// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [n,p]=%p0_2d_size(in)
     n=evstr('size('+in.geo+',''c'')');
     p=size(in.Cell,2)
endfunction
   
