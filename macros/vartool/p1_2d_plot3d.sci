// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_plot3d(%v,cbar,theta,alpha,leg,flag,ebox)
    %th=evstr(%v.geo);
    opts=[]
    if exists('theta','local')==1 then opts=[opts,'theta=theta'],end
    if exists('alpha','local')==1 then opts=[opts,'alpha=alpha'],end
    if exists('leg'  ,'local')==1 then opts=[opts,'leg=leg']    ,end
    if exists('flag' ,'local')==1 then opts=[opts,'flag=flag']  ,end
    if exists('ebox' ,'local')==1 then opts=[opts,'ebox=ebox']  ,end
    
    // set graphic properties
    my_plot3d = gcf();
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
    // test empty Node
    if %v.Node==[]
      disp(' --- Empty variable ---');bool=%f
      xset("font",1,5);
      xstring(0,0,['Please enter';'a';'variable';'to avoid this message ...']);
      xset("wdim",350,150);
      return
    end
    // colorbar
    mi=min(%v.Node); ma=max(%v.Node);
    if  exists('cbar','local')==1
      if cbar=="on"
	colorbar(mi,ma);
      end
    end
   
    // begin of the code
    xx=matrix(%th.Coor(%th.Tri,1),-1,3)';
    yy=matrix(%th.Coor(%th.Tri,2),-1,3)';
    if typeof(%th)=="tri2d"
      zz=matrix(%v.Node(%th.Tri),-1,3)';
      coul=zz;
    else
      zz=matrix(%th.Coor(%th.Tri,3),-1,3)';
      coul=matrix(%v.Node(%th.Tri),-1,3)';
    end

    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    
    index=[1 3 2]
    execstr('plot3d(xx(index,:),yy(index,:),..
	    list(zz(index,:)+max(0.0001,0.0001*(ma-mi)),coul(index,:)),'+strcat(opts,',')+')');
  
    my_plot3d.immediate_drawing=old_imdraw;
endfunction
  
