// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_plot3d(%v)
   // must be changed to admit tri3d mesh
   //
    %th=evstr(%v.geo);
    mi=min(%v.Node); ma=max(%v.Node);
    
    xx=matrix(%th.Coor(%th.Tri,1),-1,3)';
    yy=matrix(%th.Coor(%th.Tri,2),-1,3)';
    if typeof(%th)=="tri2d"
      zz=matrix(%v.Node(%th.Tri),-1,3)';
      coul=zz;
      rect =[min(%th);mi;max(%th);ma]';
      ebox=rect([1 4 2 5 3 6]);
    else
      zz=matrix(%th.Coor(%th.Tri,3),-1,3)';
      coul=matrix(%v.Node(%th.Tri),-1,3)';
      ebox=matrix([min(%th),max(%th)]',-1,1)'
    end
 
    coulmax=256;
    f=gcf()  
    f.color_map = jetcolormap(256)
    colorbar(mi,ma);
    if mi~=ma
      coul=round((coulmax-1)*(coul-mi)/(ma-mi))+1;
    else
      coul=round(coulmax/2)*ones(coul(1,:));
    end
    
    index=[1 3 2]
    plot3d(xx,yy,list(zz,coul),flag=[-2,3,4],ebox=ebox)
    if typeof(%th)=="tri2d"
      plot3d(xx(index,:),yy(index,:),..
	     list(zz(index,:)+max(0.0001,0.0001*(ma-mi)),coul(index,:))..
	     ,flag=[-2,3,4],ebox=ebox)
    end
    xtitle(name_mmodd(%v)+' : '+%v.Id)

endfunction
  
