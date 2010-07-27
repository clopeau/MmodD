// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out]=complement(in,n)
  // un bijoux !!!!
  // trouve le complement de "in" dans "1:n"
  out=~zeros(1,n);
  out(in)=%f;;
  out=find(out);
endfunction

  
