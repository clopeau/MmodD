function A = Dy(u,flag)
[lhs,rhs] = argn(0)
if (rhs == 1) then
  execstr('A = Dy_'+typeof(u)+'(u)');
else
  execstr('A = Dy_'+typeof(u)+'(u,flag)');
end
endfunction
