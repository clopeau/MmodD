// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p0_2d_plot2d(%v,cbar)
    
    %th=evstr(%v.geo);
    x_min=min(%th);
    x_max=max(%th);
    if %v.Cell==[]
      disp(' --- Empty variable ---');
      return
    end
    
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
    
    zminmax=[min(%v.Cell),max(%v.Cell)];
    colorbar(zminmax(1),zminmax(2));
    if zminmax(1)~=zminmax(2)
      coul=int((coulmax-1)*(%v.Cell-zminmax(1))/(zminmax(2)-zminmax(1)))+1;
      coul(coul>coulmax)=0;
      coul(coul<1)=0;
    else
      coul=zeros(%v.Cell);
      coul(%v.Cell==mi)=int(coulmax/2);
    end
    
    xx=matrix(%th.Coor(%th.Tri,1),-1,3)';
    yy=matrix(%th.Coor(%th.Tri,2),-1,3)';
    
    xfpolys([xx ; xx(1,:)],[yy ; yy(1,:)],coul');
    
endfunction
  
