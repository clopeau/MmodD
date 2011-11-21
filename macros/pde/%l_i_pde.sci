// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function v = %l_i_pde(varargin)
ind = varargin(1);
l = varargin($-1);
v = varargin($);
ctlr = 0;
for k=1:size(v.BndId,'*'),
 if (ind == v.BndId(k)) then
  v.BndId(k) = ind;
  v.TypBnd(k) = l(1);
  v.BndVal(k) = l(2);
  ctlr = 1;
 end
end
if (ctlr == 0) then
v.BndId($+1) = ind;
v.TypBnd($+1) = l(1);
v.BndVal($+1) = l(2);
end
endfunction
