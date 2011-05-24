function %out=%p0_2d_ones(%in)
    %th=evstr(%in.geo);
    %out=p0(%th,'1');
    %out.geo=%in.geo;
    
endfunction
