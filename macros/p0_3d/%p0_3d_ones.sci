// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=%p0_3d_ones(%in)
    %th=evstr(%in.geo);
    %out=p0(%th,'1');
    %out.geo=%in.geo;
    
endfunction
