// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=p1_3d_plot3d(%v,cbar,theta,alpha,leg,flag,ebox)
   // 3d boundary visalisation 
   // test inputs options 
   opts=[]
   if exists('theta','local')==1 then opts=[opts,'theta=theta'],end
   if exists('alpha','local')==1 then opts=[opts,'alpha=alpha'],end
   if exists('leg'  ,'local')==1 then opts=[opts,'leg=leg']    ,end
   if exists('flag' ,'local')==1 then opts=[opts,'flag=flag']  ,end
   if exists('ebox' ,'local')==1 then opts=[opts,'ebox=ebox']  ,end

   // test empty Node
   if %v.Node==[]
     disp(' --- Empty variable ---');bool=%f
     xset("font",1,5);
     xstring(0,0,['Please enter';'a';'variable';'to avoid this message ...']);
     xset("wdim",350,150);
     return
   elseif size(%v.Node,2)==3;
     %v.Node=sqrt(sum(%v.Node.^2,'c')) 
   end
   
   my_plot3d = gcf();
   my_axes=gca();
   NbChild=length(my_axes.children);
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
   
   // mesh
  %th=evstr(%v.geo);
  %nbd=length(%th.Bnd)

  // color and colorbar
  mi=min(%v.Node); ma=max(%v.Node);
  if  exists('cbar','local')==1
    if cbar=="on"
      colorbar(mi,ma);
    end
  end
  
  for fr=%th.BndId
    // Note optimal but it work
    Tri=%th(fr);
    xx=matrix(%th.Coor(Tri,1),-1,3)';
    yy=matrix(%th.Coor(Tri,2),-1,3)';
    zz=matrix(%th.Coor(Tri,3),-1,3)';
    coul=matrix(%v.Node(Tri),-1,3)';
    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    execstr('plot3d(xx,yy,list(zz,coul),'+strcat(opts,',')+')');
  end  
  my_plot3d.immediate_drawing=old_imdraw
  glue(my_axes.children(NbChild+1:$));
endfunction
