// Copyright (C) 2011-12 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_contour3d(%v,%x,cbar,theta,alpha,leg,flag,ebox)
    %th=evstr(%v.geo); 
    [np,nt]=size(%th);
    
    opts=[]
    if exists('theta','local')==1 then opts=[opts,'theta=theta'],end
    if exists('alpha','local')==1 then opts=[opts,'alpha=alpha'],end
    if exists('leg'  ,'local')==1 then opts=[opts,'leg=leg']    ,end
    if exists('flag' ,'local')==1 then opts=[opts,'flag=flag']  ,end
    if exists('ebox' ,'local')==1 then opts=[opts,'ebox=ebox']  ,end
    
    // set graphic properties
    my_plot3d = gcf();
    old_imdraw=my_plot3d.immediate_drawing;
    my_plot3d.immediate_drawing="off"
    my_axes=gca();
    NbChild=length(my_axes.children);
    // test if the color map is a standard one (suppose to be of size 32)
    if size(my_plot3d.color_map,1)==32
      coulmax=256;
      my_plot3d.color_map=jetcolormap(coulmax);
    else
      coulmax=size(my_plot3d.color_map,1);
    end
    
    // 
    if %v.Node==[]
      disp(' --- Empty variable ---');bool=%f
      xset("font",1,5);
      xstring(0,0,['Please enter';'a';'variable';'to avoid this message ...']);
      xset("wdim",350,150);
      return
    end

    // colorbar
    mi=min(%v.Node); ma=max(%v.Node);
    if  exists('cbar','local')==1
      if cbar=="on"
	colorbar(mi,ma);
      end
    end
    
    // begin of the code
    zminmax=[min(%v.Node),max(%v.Node)];
    if length(%x)==1 & int(%x)==%x & %x>0
      %x=linspace(zminmax(1),zminmax(2),%x+2);
      %x=%x(2:$-1);
    end
    EdgeLevelx=list();
    EdgeLevely=list();
    nlevel=0;
    for %lev=%x
      if %v.domain<>[]
	%tri=~ones(np,1)
	%tri(%v.BoolNode)=%v.Node<%lev;
	indtri=~ones(nt,1);
	for i=1:length(%v.domain)
	  indtri=indtri | %th.TriId==%v.domain(i);
	end
	 %tri=matrix(%tri(%th.Tri),-1,3) & indtri(:,[1 1 1]);
      else
	%tri=%v.Node<%lev;
	%tri=matrix(%tri(%th.Tri),-1,3);
      end
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
	    if %v.domain<>[]
	      fun_rec=spzeros(np,1);
	      fun_rec(%v.BoolNode)=(1:sum(%v.BoolNode))';
	      %bari=(%v.Node(full(fun_rec(%th.Tri(%ind_loc,ii))))-%lev)./ ..
		  (%v.Node(full(fun_rec(%th.Tri(%ind_loc,ii))))- ..
		  %v.Node(full(fun_rec(%th.Tri(%ind_loc,lindex(ii,jj))))));
	    else
	      %bari=(%v.Node(%th.Tri(%ind_loc,ii))-%lev)./ ..
		  (%v.Node(%th.Tri(%ind_loc,ii))- ..
		  %v.Node(%th.Tri(%ind_loc,lindex(ii,jj))));
	    end
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
      
    //colorbar(zminmax(1),zminmax(2));
    for i=1:nlevel
      if (zminmax(2)-zminmax(1))>0
	coul=coulmax*(zminmax(1)-%x(i))/(zminmax(1)-zminmax(2))
      else
	coul=coulmax/2;
      end
      n=size(EdgeLevelx(i),2);
      execstr('param3d1(EdgeLevelx(i),EdgeLevely(i),list(%x(i)*ones(2,n),coul*ones(1,n)),'+strcat(opts,',')+')');
    end
    
    my_plot3d.immediate_drawing=old_imdraw;
    glue(my_axes.children(NbChild+1:$));
endfunction
  
