// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=p1_2d_to_p0_2d(%in)
    %th=evstr(%in.geo);
    [n,nt]=size(%th);
    [n,dim]=size(%in);
    %out=p0_2d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=zeros(nt,dim)
    for i=1:dim
      %out.Cell(:,i)=sum(matrix(%in.Node(%th.Tri,i),-1,3),'c')/3;
    end

    
 endfunction
