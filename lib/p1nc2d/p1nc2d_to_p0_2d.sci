function %out=p1nc2d_to_p0_2d(%in)
    %th=evstr(%in.geo);
    %out=p0_2d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=sum(matrix(%in.Face(%th.Tri2Edg),-1,3),'c')/3;
    
 endfunction
