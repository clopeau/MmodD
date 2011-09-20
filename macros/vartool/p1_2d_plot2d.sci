// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_plot2d(%v)
    bool=%t

    %th=evstr(%v.geo); 
   
    xy_min=min(%th);
    xy_max=max(%th);
    clf();
    my_plot2d= gcf();
    my_plot2d.color_map=jetcolormap(256)
    coulmax=256;
    
    [np,nt]=size(%th);
    triangl=[(1:nt)'  %th.Tri  zeros(nt,1)]
    if %v.Node==[]
      disp(' --- No variable ---');bool=%f
    else
      zminmax=[min(%v.Node),max(%v.Node)];
      colorbar(zminmax(1),zminmax(2));
      fec(%th.Coor(:,1),%th.Coor(:,2),triangl,full(%v.Node),...
	  strf="031",rect=[xy_min',xy_max'],zminmax=zminmax)
      xtitle(name_mmodd(%v)+' : '+%v.Id)
    end
    if bool==%f,
      xset("font",1,5);
      xstring(0,0,['Please enter';'a';'variable';'to avoid this message ...']);
      xset("wdim",350,150);
    end
    
    m=uimenu('label','3d View');
    m1=uimenu(m,'label','Turn in 3d','callback','p1_2d_plot3d('+name_mmodd(%v)+')')
endfunction
  
