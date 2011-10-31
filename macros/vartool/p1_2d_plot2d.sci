// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_plot2d(%v,cbar,style,strf,leg,rect,nax,void)
  
    opts=[]
    if exists('style','local')==1 then opts=[opts,'style=style'],end
    if exists('strf','local')==1 then opts=[opts,'strf=strf'],end
    if exists('leg','local')==1 then opts=[opts,'leg=leg'],end
    if exists('rect','local')==1 then opts=[opts,'rect=rect'],end
    if exists('nax','local')==1 then opts=[opts,'nax=nax'],end
    if exists('logflag','local')==1 then opts=[opts,'logflag=logflag'],end
    if exists('frameflag','local')==1 then opts=[opts,'frameflag=frameflag'],end
    if exists('axesflag','local')==1 then opts=[opts,'axesflag=axesflag'],end
	
    %th=evstr(%v.geo); 

    if %v.Node==[]
      disp(' --- Empty variable ---');
      return
    end
    zminmax=[min(%v.Node),max(%v.Node)];

    my_plot2d= gcf();
    
    // test if the color map is a standard one (suppose to be of size 32)
    if size(my_plot2d.color_map,1)==32
      coulmax=256;
      my_plot2d.color_map=jetcolormap(coulmax);
    else
      coulmax=size(my_plot2d.color_map,1);
    end
    
    // color and colorbar
    if  exists('cbar','local')==1
      if cbar=="on"
	colorbar(zminmax(1),zminmax(2));
      end
    end
    
    [np,nt]=size(%th);
    triangl=[(1:nt)'  %th.Tri  zeros(nt,1)]
    execstr('fec(%th.Coor(:,1),%th.Coor(:,2),triangl,full(%v.Node),'+strcat(opts,',')+')')

    
endfunction
  
