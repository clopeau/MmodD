function A=Dx_df1d(u,sig)
[lhs,rhs] = argn(0)
if rhs==1
  sig='c'
end

x=evstr(u.geo+'.x');
A=%D(x,sig);

endfunction
