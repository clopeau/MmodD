function [n,p]=%RT_size(in)
     n=evstr('size('+in.geo+',''f'')');
     p=size(in.Face,2)
endfunction
   
