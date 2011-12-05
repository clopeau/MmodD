// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function v = %c_i_pde(varargin)
ind = varargin(1);
ll = matrix(varargin($-1),1,-1);
v = varargin($);
ctlr = 0;
for l=ll
  k=find(v.BndId==ind)
  if k~=[]
    v.BndId(k) = ind;
    //v.TypBnd(k) = '';
    v.BndVal(k) = l;
    ctlr = 1;
  else
    error('--- Wrong argument in boundary or equation definition ---')
  end
end
endfunction
