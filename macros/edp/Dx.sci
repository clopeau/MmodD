function A = Dx(u,flag)
[lhs,rhs] = argn(0)
if (rhs == 1) then
  execstr('A = Dx_'+typeof(u)+'(u)');
else
  execstr('A = Dx_'+typeof(u)+'(u,flag)');
end

endfunction
