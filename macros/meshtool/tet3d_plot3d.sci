// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tet3d_plot3d(%th)
// Mesh visualisation 
  // tet3d
  // boundary
  my_plot3d = gcf();
  my_plot3d.color_map=jetcolormap(256);
  
  %nbd=length(%th.Bnd)
  my_Color=round(linspace(1,256,%nbd));
  
  x_min=min(%th);
  x_max=max(%th);

  plot3d(x_min(1,ones(1,3)),x_min(2,ones(1,3)),x_min(3,ones(1,3)),flag=[0 5 2],ebox=matrix([x_min,x_max]',-1,1)')

  col=1
  for fr=%th.BndId
    tri3d_plot3d(tri3d(%th,fr),my_Color(col));
    col=col+1;
  end  

endfunction
