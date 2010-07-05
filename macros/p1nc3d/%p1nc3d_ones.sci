function %out=%p1nc3d_ones(%in)
    %th=evstr(%in.geo);
    %out=p1nc3d(%th,'1');
    %out.geo=%in.geo;
    
endfunction
