// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tri2d_plot2d(%th)
// Mesh visualisation
// th : type tri2d
 
  //---- Domain ploting ----------

  NbDom=unique(%th.TriId)

  clf();
  my_plot2d= gcf();
  my_plot2d.color_map=jetcolormap(256)

  my_Color=round(linspace(1,256,length(NbDom)));

  num_Color=0
 
  xy_min=min(%th);
  xy_max=max(%th);

  plot2d(xy_min(1),xy_min(2),frameflag=3,rect=[xy_min',xy_max']);
  
  for i=NbDom'
    num_Color=num_Color+1;
    Index = (%th.TriId==i);
    nbTriang=sum(Index);

    x=matrix(%th.Coor(%th.Tri(Index,:),1),nbTriang,3)';
    y=matrix(%th.Coor(%th.Tri(Index,:),2),nbTriang,3)';
 
    x=[x;x(1,:)];
    y=[y;y(1,:)];

    plot3d(x,y,list(zeros(x),my_Color(num_Color)*ones(1,nbTriang)),alpha=0,theta=270)
  end
  
  //---- Boundary ploting ----------
  
  %nbd=length(%th.Bnd)
  my_Color=round(linspace(128,64,%nbd));
  for i=1:%nbd
    %xy=%th.Coor(%th.Bnd(i),:);
    plot2d(%xy(:,1),%xy(:,2),my_Color(i))
  end

endfunction
