// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tri2d_plot2d(%th)
// Mesh visualisation
// th : type tri2d
 
  if %th.Id==[]
	Title=name_mmodd(%th)
  else
	Title=%th.Id
  end

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
  legends( "Domain "+string(NbDom),my_Color,opt=1)
  for i=NbDom'
    num_Color=num_Color+1;
    Index = (%th.TriId==i);
    nbTriang=sum(Index);

    x=matrix(%th.Coor(%th.Tri(Index,:),1),nbTriang,3)';
    y=matrix(%th.Coor(%th.Tri(Index,:),2),nbTriang,3)';
 
    x=[x;x(1,:)];
    y=[y;y(1,:)];

    xfpolys(x,y,my_Color(num_Color)*ones(1,nbTriang));
  end
  
  //---- Boundary ploting ----------
  %nbd=length(%th.Bnd)
  my_Color=round(linspace(128,64,%nbd));
  xset("thickness",3) 
  for i=1:%nbd
    %xy=%th.Coor(%th.Bnd(i),:);
    plot2d(%xy(:,1),%xy(:,2),my_Color(i))
  end
  legends( "Bdry "+%th.BndId,my_Color,opt=2)
  xset("thickness",1) 
  
  //---- Title ------------
  
 [%np,%nt]=size(%th);
  xtitle(Title+" : "+string(%np)+" points"+"  "+string(%nt)+" triangles")
endfunction
