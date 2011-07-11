// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=%p1_2d_zeros(%in)
    %th=evstr(%in.geo);
    %out=p1(%th,'0');
    %out.geo=%in.geo;
    
endfunction
