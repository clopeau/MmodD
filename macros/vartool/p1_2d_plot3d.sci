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
    my_axes=gca()
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
    elseif size(%v.Node,2)==2;
      %v.Node=sqrt(sum(%v.Node.^2,'c'))
    end
    // colorbar
    mi=min(%v.Node); ma=max(%v.Node);
    if  exists('cbar','local')==1
      if cbar=="on"
	colorbar(mi,ma);
      end
    end
   
    // begin of the code
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
      if typeof(%th)=="tri2d"
	zz=matrix(%v.Node(full(fun_rec(%th.Tri(indtri,index)))),-1,3)';
	coul=zz
      else
	zz=matrix(%th.Coor(%th.Tri(indtri,index),3),-1,3)';
	coul=matrix(%v.Node(full(fun_rec(%th.Tri(indtri,index)))),-1,3)';
      end
    else
      xx=matrix(%th.Coor(%th.Tri(:,index),1),-1,3)';
      yy=matrix(%th.Coor(%th.Tri(:,index),2),-1,3)';
      if typeof(%th)=="tri2d"
	zz=matrix(%v.Node(%th.Tri(:,index)),-1,3)';
	coul=zz;
      else
	zz=matrix(%th.Coor(%th.Tr(:,index),3),-1,3)';
	coul=matrix(%v.Node(%th.Tri(:,index)),-1,3)';
      end
    end

    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    
    execstr('plot3d(xx,yy,list(zz,coul),'+..
	strcat(opts,',')+')');
    my_g=gca();
    my_g.children(1).hiddencolor=-1; // recto verso
    my_g.children(1).color_mode=-1;  // without edges
    my_plot3d.immediate_drawing=old_imdraw;
endfunction
  
