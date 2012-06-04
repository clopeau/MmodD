// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function p0_2d_champ(%v,rect,scale,style,arsize)
  
    opts=[]
   
    if exists('scale','local')~=1 then scale=1,end
    if exists('style','local')~=1 then style=1,end
    if exists('arsize','local')~=1 then arsize=-1,end
    
    %th=evstr(%v.geo); 

    if %v.Cell==[]
      disp(' --- Empty variable ---');
      return
    elseif size(%v.Cell,2)<>2
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
    x=x_tri2d_Cell(%th);
    y=y_tri2d_Cell(%th);
    if %v.domain<>[]
      xarrows( [x(%v.BoolTri)-scale*%v.Cell(:,1),..
	      x(%v.BoolTri)+scale*%v.Cell(:,1)]',..
	  [y(%v.BoolTri)-scale*%v.Cell(:,2),..
	      y(%v.BoolTri)+scale*%v.Cell(:,2)]',..
	  arsize=arsize,style=style)
    else
      xarrows([x-scale*%v.Cell(:,1),x+scale*%v.Cell(:,1)]',..
      [y-scale*%v.Cell(:,2),y+scale*%v.Cell(:,2)]',arsize=arsize,style=style)
    end
    
    my_plot2d.immediate_drawing=old_imdraw;
    
    
endfunction
  
