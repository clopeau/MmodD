// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [n,p]=%p1_2d_size(in)
     if in.domain<>[]
       n=sum(in.BoolNode)
     else
       n=evstr('size('+in.geo+')');
     end
     p=size(in.Node,2)
endfunction
   
