function [n,p]=%p0_1d_size(in)
     n=evstr('size('+in.geo+',''c'')');
     p=size(in.Cell,2)
endfunction
   
