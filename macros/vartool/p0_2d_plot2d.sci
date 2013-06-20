// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p0_2d_plot2d(%v,cbar,strf,leg,ebox,nax)
    
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
	
    // set graphic properties
    my_plot3d = gcf();
    my_axes=gca();
    my_axes.hiddencolor=-1;
    old_imdraw=my_plot3d.immediate_drawing;
    my_plot3d.immediate_drawing="off"
    // test if the color map is a standard one (suppose to be of size 32)
    if size(my_plot3d.color_map,1)==32
      coulmax=256;
      my_plot3d.color_map=jetcolormap(coulmax);
    else
      coulmax=size(my_plot3d.color_map,1);
    end
    
    // variable
    if %v.Cell==[]
      disp(' --- Empty variable ---');
      return
    elseif  size(%v.Cell,2)==2;
      %v.Cell=sqrt(sum(%v.Cell.^2,'c'))
    end
    mi=min(%v.Cell); ma=max(%v.Cell);
    if  exists('cbar','local')==1
      if cbar=="on"
	colorbar(mi,ma);
      end
    end
    
    // mesh
    %th=evstr(%v.geo);
    // begin of the code
    xx=matrix(%th.Coor(%th.Tri,1),-1,3)';
    yy=matrix(%th.Coor(%th.Tri,2),-1,3)';
    zz=%v.Cell(:,[1 1 1])';
    
    coul=zz(1,:)
    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    
    execstr('plot3d(xx,yy,list(zz,coul),alpha=0,theta=270,'+strcat(opts,',')+')');

    my_g=gca();
    my_g.z_ticks.labels=""  // remove z axis labels
    my_g.children(1).hiddencolor=-1; // recto verso
    my_g.children(1).color_mode=-1;  // without edges
    my_plot3d.immediate_drawing=old_imdraw;    
    
endfunction
  
