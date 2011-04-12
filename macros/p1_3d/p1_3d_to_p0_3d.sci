// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=p1_3d_to_p0_3d(%in)
    %th=evstr(%in.geo);
    [n,nt]=size(%th);
    [n,dim]=size(%in);
    %out=p0_3d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=zeros(nt,dim)
    for i=1:dim
      %out.Cell(:,i)=sum(matrix(%in.Node(%th.Tet,i),-1,4),'c')/4;
    end
 endfunction
