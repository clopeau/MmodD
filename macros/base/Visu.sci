function Visu(G,col)
  [lhs,rhs]=argn(0);
  if rhs==1
    col=3;
  end
  t=typeof(G);
  execstr(t+'_plot(G,col)');
endfunction
