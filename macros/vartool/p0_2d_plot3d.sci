// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p0_2d_plot3d(%v,cbar,theta,alpha,leg,flag,ebox)
    %th=evstr(%v.geo);
    opts=[]
    if exists('theta','local')==1 then opts=[opts,'theta=theta'],end
    if exists('alpha','local')==1 then opts=[opts,'alpha=alpha'],end
    if exists('leg'  ,'local')==1 then opts=[opts,'leg=leg']    ,end
    if exists('flag' ,'local')==1 then opts=[opts,'flag=flag']  ,end
    if exists('ebox' ,'local')==1 then opts=[opts,'ebox=ebox']  ,end
    
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
    
    execstr('plot3d([xx xx($:-1:1,:)],[yy yy($:-1:1,:)],..
	list([zz,zz($:-1:1,:)],[coul,coul($:-1:1,:)]),'+strcat(opts,',')+')');

    my_plot3d.immediate_drawing=old_imdraw;    
endfunction
  
