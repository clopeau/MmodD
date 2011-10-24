// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p0_2d_plot2d(%v)
    %th=evstr(%v.geo);
    x_min=min(%th);
    x_max=max(%th);
    my_plot2d= gcf();
    coulmax=256;
    my_plot2d.color_map=jetcolormap(coulmax)
    plot2d(x_min(1),x_min(2),frameflag=3,rect=[x_min',x_max']);
    
    [np,nt]=size(%th);
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
    xtitle(name_mmodd(%v)+' : '+%v.Id)

    m=uimenu('label','3d View');
    m1=uimenu(m,'label','Turn in 3d','callback','p0_2d_plot3d('+name_mmodd(%v)+')')
    
endfunction
  
