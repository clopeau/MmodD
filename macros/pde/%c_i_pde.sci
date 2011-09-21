// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function v = %c_i_pde(varargin)
ind = varargin(1);
ll = matrix(varargin($-1),1,-1);
v = varargin($);
ctlr = 0;
test_bool='false'
th=evstr(v.geo)
for l=ll
  for k=1:length(v.BndId),
      if (ind == v.BndId(k)) then
      v.BndId(k) = ind;
      v.TypBnd(k) = '';
      v.BndVal(k) = l;
      ctlr = 1;
      test_bool= 'true'
    end
  end
  if (ctlr == 0) then
    for p=th.BndId
      if ind==p
    v.BndId($+1) = ind;
    v.TypBnd($+1) = '';
    v.BndVal($+1) = l;
    test_bool= 'true'
    end
  end
  if test_bool== 'false', disp('  a --- wrong argument in boundary or equation definition --- ');end
  end
end
endfunction
