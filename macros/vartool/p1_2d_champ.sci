// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p1_2d_champ(%v,rect,scale,style,arsize)
  
    opts=[]
   
    if exists('scale','local')~=1 then scale=1,end
    if exists('style','local')~=1 then style=1,end
    if exists('arsize','local')~=1 then arsize=-1,end
    
    %th=evstr(%v.geo); 

    if %v.Node==[]
      disp(' --- Empty variable ---');
      return
    elseif size(%v.Node,2)<>2
      error('The argument must be a vector');
      return
    end

    my_plot2d= gcf();
    my_axes=gca()
    if my_axes.children==[]
      if exists('rect','local')==1 then 
	my_axes.data_bounds=rect
      else
	my_axes.data_bounds=[min(th),max(th)]';
      end
    end
    old_imdraw=my_plot2d.immediate_drawing;
    my_plot2d.immediate_drawing="off"

    scale=scale/2;
    
    [np,nt]=size(%th);
    index=[1 3 2]
    if %v.domain<>[]
      xarrows([%th.Coor(%v.BoolNode,1)-scale*%v.Node(:,1),..
	      %th.Coor(%v.BoolNode,1)+scale*%v.Node(:,1)]',..
	  [%th.Coor(%v.BoolNode,2)-scale*%v.Node(:,2),..
	      %th.Coor(%v.BoolNode,2)+scale*%v.Node(:,2)]',..
	  arsize=arsize,style=style)
    else
      xarrows([%th.Coor(:,1)-scale*%v.Node(:,1),..
	      %th.Coor(:,1)+scale*%v.Node(:,1)]',..
	  [%th.Coor(:,2)-scale*%v.Node(:,2),..
	      %th.Coor(:,2)+scale*%v.Node(:,2)]',arsize=arsize,style=style)
    end
    
    my_plot2d.immediate_drawing=old_imdraw;
    
    
endfunction
  
