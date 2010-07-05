function [n,p]=%p1nc3d_size(in)
     execstr('[nf,nf,n]=size('+in.geo+')');
     p=size(in.Face,2)
endfunction
   
