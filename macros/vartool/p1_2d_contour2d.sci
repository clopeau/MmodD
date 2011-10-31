// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_contour2d(%v,%x,cbar,style,strf,leg,rect,nax,logflag,frameflag,axesflag)
     opts=[]
     if exists('style','local')==1 then opts=[opts,'style=style'],end
     if exists('strf','local')==1 then opts=[opts,'strf=strf'],end
     if exists('leg','local')==1 then opts=[opts,'leg=leg'],end
     if exists('rect','local')==1 then opts=[opts,'rect=rect'],end
     if exists('nax','local')==1 then opts=[opts,'nax=nax'],end
     if exists('logflag','local')==1 then opts=[opts,'logflag=logflag'],end
     if exists('frameflag','local')==1 then opts=[opts,'frameflag=frameflag'],end
     if exists('axesflag','local')==1 then opts=[opts,'axesflag=axesflag'],end
	
  
     %th=evstr(%v.geo); 

     if %v.Node==[]
       disp(' --- Empty variable ---');
       return
     end
     
     // Graphic config
     my_plot2d= gcf();
     old_imdraw=my_plot2d.immediate_drawing;
     my_plot2d.immediate_drawing="off"
     my_axes=gca();
     NbChild=length(my_axes.children);
     
     // test if the color map is a standard one (suppose to be of size 32)
     if size(my_plot2d.color_map,1)==32
       coulmax=256;
       my_plot2d.color_map=jetcolormap(coulmax);
     else
       coulmax=size(my_plot2d.color_map,1);
     end
     
     zminmax=[min(%v.Node),max(%v.Node)];
     // color and colorbar
     if  exists('cbar','local')==1
       if cbar=="on"
	 colorbar(zminmax(1),zminmax(2));
       end
     end
        
    // test on numder of level or values 
    if length(%x)==1 & int(%x)==%x & %x>0
      %x=linspace(zminmax(1),zminmax(2),%x+2);
      %x=%x(2:$-1);
    end
    EdgeLevelx=list();
    EdgeLevely=list();
    nlevel=0;
    for %lev=%x
      %tri=%v.Node<%lev;
      %tri=matrix(%tri(%th.Tri),-1,3);
      %stri=sum(%tri,'c');
      // search triangle
      %ind= %stri==2;
      %tri(%ind,:)=~%tri(%ind,:);
      %stri(%ind)=1;
      %ind=find(%stri==1);
      lindex=[2 3; 3 1; 1 2];
      %XX=[];%YY=[];
      for ii=1:3
	%ind_loc=%ind(find(%tri(%ind,ii)));
	if length(%ind_loc)>0
	  %X=zeros(length(%ind_loc),2);
	  %Y=zeros(length(%ind_loc),2);
	  for jj=1:2
	    %bari=zeros(length(%ind_loc));
	    %bari=(%v.Node(%th.Tri(%ind_loc,ii))-%lev)./ ..
		(%v.Node(%th.Tri(%ind_loc,ii))- ..
		 %v.Node(%th.Tri(%ind_loc,lindex(ii,jj))));
	    %XY=%th.Coor(%th.Tri(%ind_loc,ii),:)- ..
		%bari(:,[1 1]).*(%th.Coor(%th.Tri(%ind_loc,ii),:)- ...
			      %th.Coor(%th.Tri(%ind_loc,lindex(ii,jj)),:));
	    %X(:,jj)=%XY(:,1);
	    %Y(:,jj)=%XY(:,2);
	  end
	  %XX=[%XX ; %X];
	  %YY=[%YY ; %Y];
	end
      end
      if %XX<>[]
	EdgeLevelx($+1)=%XX';
	EdgeLevely($+1)=%YY';
	nlevel=nlevel+1
      else
	%x(%x==%lev)=[];
      end
    end
      
    for i=1:nlevel
      if (zminmax(2)-zminmax(1))>0
	coul=coulmax*(zminmax(2)-%x(i))/(zminmax(2)-zminmax(1))
      else
	coul=coulmax/2;
      end
      n=size(EdgeLevelx(i),2);
      execstr('plot2d(EdgeLevelx(i),EdgeLevely(i),coul*ones(1:n),'+strcat(opts,',')+')');
    end
    
    my_plot2d.immediate_drawing=old_imdraw
    glue(my_axes.children(NbChild+1:$));
endfunction
  
