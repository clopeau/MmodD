// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tet3d_plot(th)
// Mesh visualisation 
  f = gca();
  col=1
  for fr=th.BndId
    tri3d_plot(tri3d(th,fr),col);
    col=col+1;
  end
  
  
  legends(th.BndId',1:col-1,4)

endfunction
