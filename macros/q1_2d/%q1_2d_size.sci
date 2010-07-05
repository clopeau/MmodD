function [n,p]=%q1_2d_size(in)
     n=evstr('size('+in.geo+')');
     p=size(in.Node,2)
endfunction
   
