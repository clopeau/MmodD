// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %grid1d_p(G)

  write(%io(2),'Type grid1d : '+G.id+'  '+string(length(G.x)));
  write(%io(2),' ');
  write(%io(2),'    xmin = '+string(min(G.x))+'  xmax = '+ ...
        string(max(G.x)));
endfunction
