function grid2d_plot(G,col)
  [lhs,rhs]=argn(0);
  if rhs==1
    col=3;
  end

  //plot2d(0,0,0,rect=[min(G) max(G)])
  xset("clipgrf");
  a=G.y(1); b=G.y($);
  xsegs([G.x G.x]',[a(ones(G.x)) b(ones(G.x))]',col*ones(G.x));
  a=G.x(1); b=G.x($);
  xsegs([a(ones(G.y)) b(ones(G.y))]',[G.y G.y]',col*ones(G.y));
  xset("clipoff");
endfunction
