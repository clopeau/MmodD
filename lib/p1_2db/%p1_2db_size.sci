function [n,t,p]=%p1_2db_size(in)
     execstr('[n,t]=size('+in.geo+')');
     p=size(in.Node,2)
endfunction
   
