function [out]=complement(in,n)
  // un bijoux !!!!
  // trouve le complement de "in" dans "1:n"
  out=~zeros(1,n);
  out(in)=%f;;
  out=find(out);
endfunction

  
