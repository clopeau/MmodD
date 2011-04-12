// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=p1_2d_to_p0_2d(%in)
    %th=evstr(%in.geo);
    %out=p0_2d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=sum(matrix(%in.Node(%th.Tri),-1,3),'c')/3;
    
 endfunction
