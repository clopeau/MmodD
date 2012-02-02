// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tri3d_plot3d(%th,theta,alpha,leg,flag,ebox,edge,boundary,domain,color_edge,color_bnd,color_dom)
// Mesh visualisation 
// th : type tri3d
  opts=[]
  if exists('theta','local')==1 then opts=[opts,'theta=theta'],end
  if exists('alpha','local')==1 then opts=[opts,'alpha=alpha'],end
  if exists('leg','local') ==1 then opts=[opts,'leg=leg']  ,  end
  if exists('flag','local')==1 then opts=[opts,'flag=flag'],  end
  if exists('ebox','local')==1 then opts=[opts,'ebox=ebox'],  end

  my_plot3d= gcf();
  
  // test if the color map is a standard one (suppose to be of size 32)
  if size(my_plot3d.color_map,1)==32
    coulmax=256;
    my_plot3d.color_map=jetcolormap(coulmax);
  else
    coulmax=size(my_plot3d.color_map,1);
  end
  
  //---- Domains plot ----------
  if exists('domain','local')==0 then domain="on",end
  if exists('edge','local'  )==0 then  edge="on" ,end
  if domain=="on" | edge=="on" 
    NbDom=unique(%th.TriId)
    if exists('color_dom','local')==1
      my_Color=matrix(color_dom,-1,1);
      if length(NbDom)~=length(my_Color)
	error('tri3d_plot3d : incompatible size dimension with color_dom')
      end
    else 
      my_Color=round(linspace(1,coulmax,length(NbDom)));
    end
    
    
    num_Color=0
    for i=NbDom'
      num_Color=num_Color+1;
      Index = (%th.TriId==i);
      nbTriang=sum(Index);
      
      x=matrix(%th.Coor(%th.Tri(Index,:),1),nbTriang,3)';
      y=matrix(%th.Coor(%th.Tri(Index,:),2),nbTriang,3)';
      z=matrix(%th.Coor(%th.Tri(Index,:),3),nbTriang,3)';
      
      x=[x([1 3 2],:);x(1,:)];
      y=[y([1 3 2],:);y(1,:)];
      z=[z([1 3 2],:);z(1,:)];
      execstr("plot3d(x,y,list(z,my_Color(num_Color)*ones(1,nbTriang)),"+..
	  strcat(opts,',')+")") 
      //--- options  domain=="on"  edge=="on" 
      my_g=gca();
      my_g.children(1).hiddencolor=-1; // recto verso
      if domain=="on" & edge=="off" 
	my_g.children(1).color_mode=-1;
      elseif domain=="off" & edge=="on" 
	my_g.children(1).color_mode=0;
      end
    end
  end

  //---- Boundaries plot ----------
  if exists('boundary','local')==0 then boundary="on",end
  %nbd=length(%th.Bnd)
  if boundary=="on" & %nbd>0
    if exists('color_bnd','local')==1
      my_Color=matrix(color_bnd,-1,1);
      if %nbd~=length(my_Color)
	error('tri3d_plot3d : incompatible size dimension with color_bnd')
      end
    else 
      my_Color=round(linspace(1,coulmax,%nbd));
    end
    for i=1:%nbd
      %xy=%th.Coor(%th.Bnd(i),:)';
      xsegs([%xy(1,1:$-1);%xy(1,2:$)],..
	  [%xy(2,1:$-1);%xy(2,2:$)],..
	  [%xy(3,1:$-1);%xy(3,2:$)],my_Color(i))
      my_g=gca();
      my_g.children(1).thickness=2
    end
  end
endfunction

