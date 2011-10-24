// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_contour2d(%v,%x)
    %th=evstr(%v.geo); 
    //xy_min=min(%th);
    //xy_max=max(%th);

    my_plot2d= gcf();
    my_plot2d.color_map=jetcolormap(256)
    coulmax=256;
    old_imdraw=my_plot2d.immediate_drawing;
    my_plot2d.immediate_drawing="off"
    
    [np,nt]=size(%th);
    
    // 
    if %v.Node==[]
      disp(' --- Empty variable ---');bool=%f
      xset("font",1,5);
      xstring(0,0,['Please enter';'a';'variable';'to avoid this message ...']);
      xset("wdim",350,150);
      return
    end

    zminmax=[min(%v.Node),max(%v.Node)];
    if length(%x)==1 & int(%x)==%x & %x>0
      %x=linspace(zminmax(1),zminmax(2),%x+2);
      %x=%x(2:$-1);
    end
    EdgeLevelx=list();
    EdgeLevely=list();
    nlevel=0;
    for %lev=%x
      %Bool=%v.Node<%lev;
      %tri=matrix(%Bool(%th.Tri),-1,3);
      // search triangle
      %tri(sum(%tri,'c')==2,:)=~%tri(sum(%tri,'c')==2,:);
      %ind=find(sum(%tri,'c')==1);
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
			      %th.Coor(%th.Tri(%ind_loc,lindex(ii,jj),:),:));
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
      
    //colorbar(zminmax(1),zminmax(2));
    for i=1:nlevel
      if (zminmax(2)-zminmax(1))>0
	coul=coulmax*(zminmax(2)-%x(i))/(zminmax(2)-zminmax(1))
      else
	coul=coulmax/2;
      end
      n=size(EdgeLevelx(i),2);
      plot2d(EdgeLevelx(i),EdgeLevely(i),coul*ones(1:n))
    end
    my_plot2d.immediate_drawing=old_imdraw
endfunction
  
