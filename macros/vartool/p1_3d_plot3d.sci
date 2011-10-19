// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=p1_3d_plot3d(%v)
// Mesh visualisation 
  // tet3d
  // boundary
  my_plot3d = gcf();
  coulmax=256;
  my_plot3d.color_map=jetcolormap(coulmax);

  // mesh
  %th=evstr(%v.geo);
  %nbd=length(%th.Bnd)
  
  // color and colorbar
  mi=min(%v.Node); ma=max(%v.Node);
  colorbar(mi,ma);
 

  // plot3d rectangular settings
  x_min=min(%th);
  x_max=max(%th);

  plot3d(x_min(1,ones(1,3)),x_min(2,ones(1,3)),x_min(3,ones(1,3)),flag=[-2 ...
		   3 4],ebox=matrix([x_min,x_max]',-1,1)')

  for fr=%th.BndId
    %fh=tri3d(%th,fr);
    %uloc=%v(fr);
    xx=matrix(%fh.Coor(%fh.Tri,1),-1,3)';
    yy=matrix(%fh.Coor(%fh.Tri,2),-1,3)';
    zz=matrix(%fh.Coor(%fh.Tri,3),-1,3)';
    coul=matrix(%uloc(%fh.Tri),-1,3)';
    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    plot3d(xx,yy,list(zz,coul),flag=[-2 3 4]);
  end  

endfunction
