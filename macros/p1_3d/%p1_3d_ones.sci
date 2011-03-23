function %out=%p1_3d_ones(%in)
    %th=evstr(%in.geo);
    %out=p1(%th,'1');
    %out.geo=%in.geo;
    
endfunction
