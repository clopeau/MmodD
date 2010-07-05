function %out=p1_1d_to_p0_1d(%in)
    %th=evstr(%in.geo);
    %out=p0_1d();
    %out.geo=%in.geo;
    %out.Id=%in.Id;
    %out.Cell=(%in.Node(1:$-1)+%in.Node(2:$))/2;
    
 endfunction
