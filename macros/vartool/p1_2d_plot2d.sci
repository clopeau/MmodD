// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_plot2d(%v,cbar,strf,leg,ebox,nax)
  
    opts=[]
    //if exists('style','local')==1 then opts=[opts,'style=style'],end
    if exists('strf','local')==1 then opts=[opts,'strf=strf'],end
    if exists('leg','local')==1 then       
      opts=[opts,'leg=leg']
      tmp=strindex(leg,"@")
      if length(tmp)<3 then leg=leg+"@", end
    else
      opts=[opts,'leg=leg']
      leg="X@Y@";
    end
    if exists('ebox','local')==1 then 
      opts=[opts,'ebox=ebox']
      if length(ebox)==4 then ebox=[ebox 0 0], end
    end
    if exists('nax','local')==1 then opts=[opts,'nax=nax'],end
    //if exists('logflag','local')==1 then opts=[opts,'logflag=logflag'],end
    //if exists('frameflag','local')==1 then opts=[opts,'frameflag=frameflag'],end
    //if exists('axesflag','local')==1 then opts=[opts,'axesflag=axesflag'],end
	
    %th=evstr(%v.geo); 

    if %v.Node==[]
      disp(' --- Empty variable ---');
      return
    end
    zminmax=[min(%v.Node),max(%v.Node)];

    my_plot2d= gcf();
    my_axes=gca()
    my_axes.hiddencolor=-1;
    old_imdraw=my_plot2d.immediate_drawing;
    my_plot2d.immediate_drawing="off"
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
    index=[1 3 2]
    if %v.domain<>[]
      indtri=~zeros(nt,1);
      fun_rec=spzeros(np,1);
      fun_rec(%v.BoolNode)=(1:sum(%v.BoolNode))';
      indtri=~indtri;
      for i=1:length(%v.domain)
	indtri=indtri | %th.TriId==%v.domain(i);
      end
      xx=matrix(%th.Coor(%th.Tri(indtri,index),1),-1,3)';
      yy=matrix(%th.Coor(%th.Tri(indtri,index),2),-1,3)';
      coul=matrix(%v.Node(full(fun_rec(%th.Tri(indtri,index)))),-1,3)';
    else
      xx=matrix(%th.Coor(%th.Tri(:,index),1),-1,3)';
      yy=matrix(%th.Coor(%th.Tri(:,index),2),-1,3)';
      coul=matrix(%v.Node(%th.Tri(:,index)),-1,3)';
    end
    if zminmax(1)~=zminmax(2)
      coul=round((coulmax-1)*(coul- zminmax(1))/(zminmax(2)-zminmax(1)))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    
    
    execstr('plot3d(xx,yy,list(zeros(xx),coul),alpha=0,theta=270,'+..
	strcat(opts,',')+')')
    my_g=gca();
    my_g.z_ticks.labels=""  // remove z axis labels
    my_g.children(1).hiddencolor=-1; // recto verso
    my_g.children(1).color_mode=-1;  // without edges
    my_plot2d.immediate_drawing=old_imdraw;
    
endfunction
  
