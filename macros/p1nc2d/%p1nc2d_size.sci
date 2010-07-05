function [n,p]=%p1nc2d_size(in)
     n=evstr('size('+in.geo+')');
     p=size(in.Face,2)
endfunction
   
