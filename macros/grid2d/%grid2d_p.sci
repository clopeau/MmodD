function %grid2d_p(G)

  write(%io(2),'Type grid2d : '+G.id+'  '+string(length(G.x))...
        +'x'+string(length(G.y)));
  write(%io(2),' ');
  write(%io(2),'    xmin = '+string(min(G.x))+'  xmax = '+ ...
        string(max(G.x)));
  write(%io(2),'    ymin = '+string(min(G.y))+'  ymax = '+ ...
        string(max(G.y)));
endfunction
