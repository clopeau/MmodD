function [n,p]=%df3d_size(in)
     n=evstr('size('+in.geo+')');
     p=size(in.Node,2)
endfunction
   
