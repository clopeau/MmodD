// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=p1_1d_to_p0_1d(%in)
    %th=evstr(%in.geo);
    %out=p0_1d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=(%in.Node(1:$-1)+%in.Node(2:$))/2;
    
 endfunction
