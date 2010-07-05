function %out=p1nc3d_to_p0_3d(%in)
    %th=evstr(%in.geo);
    [n,nt]=size(%th);
    [n,dim]=size(%in);
    %out=p0_3d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=zeros(nt,dim)
    for i=1:dim
      %out.Cell(:,i)=sum(matrix(%in.Face(%th.Tet2Tri,i),-1,4),'c')/4;
    end
 endfunction
