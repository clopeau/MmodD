// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tet3d_plot3d(%th,theta,alpha,leg,flag,ebox,edge,boundary,domain,color_edge,color_bnd,color_dom)
// Mesh visualisation 
  // tet3d
  opts=[]
  if exists('theta','local')==1 then opts=[opts,'theta=theta'],end
  if exists('alpha','local')==1 then opts=[opts,'alpha=alpha'],end
  if exists('leg','local') ==1 then opts=[opts,'leg=leg']  ,  end
  if exists('flag','local')==1 then opts=[opts,'flag=flag'],  end
  if exists('ebox','local')==1 then opts=[opts,'ebox=ebox'],  end
  if exists('edge','local')==1 then opts=[opts,'edge=edge'],  end

  my_plot3d = gcf();
  // test if the color map is a standard one (suppose to be of size 32)
  if size(my_plot3d.color_map,1)==32
    coulmax=256;
    my_plot3d.color_map=jetcolormap(coulmax);
  else
    coulmax=size(my_plot3d.color_map,1);
  end
  //---- Boundaries plot ----------
  if exists('boundary','local')==0 then boundary="on",end
  if boundary=="on"
    %nbd=length(%th.Bnd)
    if exists('color_bnd','local')==1
      my_Color=matrix(color_bnd,-1,1);
      if %nbd~=length(my_Color)
	error('tri3d_plot3d : incompatible size dimension with color_bnd')
      end
    else 
      my_Color=round(linspace(1,coulmax,%nbd));
    end
    
    col=1
    for fr=%th.BndId
      execstr("tri3d_plot3d(tri3d(%th,fr),color_dom=my_Color(col),"+strcat(opts,',')+")");
      col=col+1;
    end  
  end

endfunction
