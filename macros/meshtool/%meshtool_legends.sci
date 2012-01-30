// Copyright (C) 2012 - BIKATT BIMAI Massoda
// Copyright (C) 2012 - Clopeau Thierry
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// 

function %meshtool_legends(BndId, ColorBnd, DomId, ColorDom)
//    Add new axe Axe 
  
  font_size = 1 ; // default size

  //preserve current graphic context
  f=gcf()
  
  //defer the drawing to avoid binking
  id=f.immediate_drawing=='on';
  if id then f.immediate_drawing=='off',end
  
   // get current axes and properties
  old_ax=gca(); 
  wr=old_ax.axes_bounds; //get the rectangle of the current axes
  // modify the orginal axes to let space for the legend
  old_ax.axes_bounds=[wr(1) , wr(2) , 0.8*wr(3) , wr(4)]
  old_ax.margins=[old_ax.margins(1) 0.02 old_ax.margins(2:3)]
  
  // create a new axes for the legends and set its properties
  a=newaxes(); 
  a.axes_bounds=[wr(1)+0.8*wr(3) , wr(2) , 0.15*wr(3) , wr(4)];
  a.data_bounds=[0 0;1 1];
  a.foreground=old_ax.foreground;
  a.background=f.background;
  a.axes_visible='off';
  a.y_location = "right";
  a.tight_limits ="on";
  a.font_color=old_ax.font_color ;
  a.font_size =old_ax.font_size  ;
  a.font_style=old_ax.font_style ;
  a.margins=[0 -0.2 a.margins(3:4)];
  a.clip_state='off';

// Boundaries legends
  BndId=matrix(BndId,-1,1);
  ColorBnd=matrix(ColorBnd,-1,1);
  if size(BndId,1)==size(ColorBnd,1) & size(BndId,1)>0
    // Title
    if size(BndId,1)==1
      BndTitle="Boundary"
    else
      BndTitle="Boundaries"
    end   
    rect=xstringl(0,0,BndTitle,a.font_style,a.font_size)
    xpos=0.5-rect(3)/2;
    ypos=1-rect(4);
    xstring(xpos,ypos,BndTitle);
// Boundaries
// names
    rect=xstringl(0,0,BndId,a.font_style,a.font_size)
    box_x=0.1;
    ypos=ypos-rect(4);
    xpos=1.5*box_x
    xstring(xpos,ypos,BndId);
// color boxes
    nbx=length(ColorBnd);
    h=rect(4)/nbx;
    xpol=[0 box_x box_x 0];
    for i=1:nbx
      box_y= ypos +rect(4)-i*h,
      ypol=[box_y box_y box_y+0.85*h box_y+0.85*h]
      xfpoly(xpol,ypol,ColorBnd(i));
    end
  end
  
// Domain legends
  if exists('DomId','local')
    DomId=matrix(DomId,-1,1);
    ColorDom=matrix(ColorDom,-1,1);
    if size(DomId,1)==size(ColorDom,1) & size(DomId,1)>0
// Title
      if size(DomId,1)==1
	DomTitle="Domain"
      else
	DomTitle="Domains"
      end   
      rect=xstringl(0,0,BndTitle,a.font_style,a.font_size)
      xpos=0.5-rect(3)/2;
      ypos=ypos-2*rect(4);
      xstring(xpos,ypos,DomTitle);
// Domains names
      rect=xstringl(0,0,DomId,a.font_style,a.font_size)
      box_x=0.1;
      ypos=ypos-rect(4);
      xpos=1.5*box_x
      xstring(xpos,ypos,DomId);   
// color boxes
      nbx=length(ColorDom);
      h=rect(4)/nbx;
      xpol=[0 box_x box_x 0];
      for i=1:nbx
	box_y= ypos +rect(4)-i*h,
	ypol=[box_y box_y box_y+0.85*h box_y+0.85*h]
	xfpoly(xpol,ypol,ColorDom(i));
      end
    end
  end
  
 
 
  if id then f.immediate_drawing='on',end

  set('current_axes',old_ax),
  
  // if immediate_drawing was "on", then the figure will redraw itself.

endfunction
