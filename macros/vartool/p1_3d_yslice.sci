// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_3d_yslice(%v,%x)
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

zminmax=[min(%v),max(%v)];
if length(%x)==1 & int(%x)==%x & %x>0
  xyzminmax=[min(th) max(th)]
  %x=linspace(xyzminmax(2,1),xyzminmax(2,2),%x+2);
  %x=%x(2:$-1);
end
dim=2;

for %lev=%x
  %tet = %th.Coor(:,dim)<%lev;
  %tet = matrix(%tet(%th.Tet),-1,4);
  %stet= sum(%tet,'c');
  //============================================
  // search 1 point less than or great then %lev 
  //============================================
  %ind=(%stet==3);
  %tet(%ind,:)=~%tet(%ind,:);
  %stet(%ind)=1;
  %ind=find(%stet==1);
  lindex=[2 3 4; 3 4 1; 4 1 2; 1 2 3];
  %XX=[];%YY=[];%ZZ=[];VNode=[];
  // ii position of unique point outside the level
  for ii=1:4
    %ind_loc=%ind(find(%tet(%ind,ii)));
    if length(%ind_loc)>0
      %X=zeros(length(%ind_loc),3);
      %Y=zeros(length(%ind_loc),3);
      %Z=zeros(length(%ind_loc),3);
      vNode=zeros(length(%ind_loc),3);
      for jj=1:3
	%bari  = zeros(length(%ind_loc));
	i_left = %th.Tet(%ind_loc,ii);
	i_right= %th.Tet(%ind_loc,lindex(ii,jj))
	%bari=(%th.Coor(i_left,dim)-%lev)./ ..
	    (%th.Coor(i_left,dim)-%th.Coor(i_right,dim));
	%XY=%th.Coor(i_left,:)- ..
	    %bari(:,[1 1 1]).*(%th.Coor(i_left,:)-%th.Coor(i_right,:));
	vNode(:,jj)=%v.Node(i_left)-..
	    %bari.*(%v.Node(i_left)-%v.Node(i_right))
	%X(:,jj)=%XY(:,1);
	%Y(:,jj)=%XY(:,2);
	%Z(:,jj)=%XY(:,3);
      end
      %XX=[%XX , %X'];
      %YY=[%YY , %Y'];
      %ZZ=[%ZZ , %Z'];
      VNode=[VNode, vNode'];
    end
  end
  if %XX<>[]
    VNode=round(coulmax*(VNode-zminmax(1))/(zminmax(2)-zminmax(1)))
    plot3d(%XX,%YY,list(%ZZ,VNode),flag=[-2,2,4]);
    a=gce();
    a.hiddencolor=-1;
  end
  //============================================
  // search 2 points less than or great then %lev
  //============================================
  %ind=find(%stet==2);
  %XX=[];%YY=[];%ZZ=[];VNode=[];
  // ii position of unique point outside the level
  ii =[1 2; 1 3;1 4]';
  iic=[3 4; 2 4;2 3]';
  for i=1:3
    %ind_loc=%ind(find(and(%tet(%ind, ii(:,i)),'c')));
    %ind_loc=[%ind_loc , %ind(find(and(%tet(%ind,iic(:,i)),'c')))];
    if length(%ind_loc)>0
      %X=zeros(length(%ind_loc),3);
      %Y=zeros(length(%ind_loc),3);
      %Z=zeros(length(%ind_loc),3);
      vNode=zeros(length(%ind_loc),3);
      for j=1:2
	for k=1:2
	  %bari=zeros(length(%ind_loc));
	  i_left = %th.Tet(%ind_loc,ii(j,i))
	  i_right= %th.Tet(%ind_loc,iic(k,i))
	  %bari=(%th.Coor(i_left,dim)-%lev)./ ..
	      (%th.Coor(i_left,dim)-%th.Coor(i_right,dim));
	  %XY=%th.Coor(i_left,:)- ..
	      %bari(:,[1 1 1]).*(%th.Coor(i_left,:)-%th.Coor(i_right,:));
	  vNode(:,j+(k-1)*2)=%v.Node(i_left)-..
	      %bari.*(%v.Node(i_left)-%v.Node(i_right))
	  %X(:,j+(k-1)*2)=%XY(:,1);
	  %Y(:,j+(k-1)*2)=%XY(:,2);
	  %Z(:,j+(k-1)*2)=%XY(:,3);
	end
      end
      %XX=[%XX , %X(:,[1 2 4 3])'];
      %YY=[%YY , %Y(:,[1 2 4 3])'];
      %ZZ=[%ZZ , %Z(:,[1 2 4 3])'];
      VNode=[VNode, vNode(:,[1 2 4 3])'];
    end
  end
  if %XX<>[]
    VNode=round(coulmax*(VNode-zminmax(1))/(zminmax(2)-zminmax(1)))
    plot3d(%XX,%YY,list(%ZZ,VNode),flag=[-2,2,4]);
    a=gce();
    a.hiddencolor=-1;
  end
end

my_plot2d.immediate_drawing=old_imdraw
endfunction

