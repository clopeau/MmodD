function %df1d_plot2d(u)
  x=evstr(u.geo+'.x');
  plot2d(x,u.Node);
  xtitle(u.Id);
endfunction