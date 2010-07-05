function v = %c_i_edp(varargin)
ind = varargin(1);
ll = matrix(varargin($-1),1,-1);
v = varargin($);
ctlr = 0;
for l=ll
  for k=1:length(v.BndId),
    if (ind == v.BndId(k)) then
      v.BndId(k) = ind;
      v.TypBnd(k) = '';
      v.BndVal(k) = l;
      ctlr = 1;
    end
  end
  if (ctlr == 0) then
    v.BndId($+1) = ind;
    v.TypBnd($+1) = '';
    v.BndVal($+1) = l;
  end
end
endfunction
