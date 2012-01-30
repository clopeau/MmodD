// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - BIKATT BIMAI Massoda
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// 

function mmodd_legends(leg, my_color , with_box, font_size )
//
// PURPOSE
//    draw legends on a plot
// AUTHORS
//    F. Delebecque + slight modif from B. Pincon
//  modified again by Eric Dubois and Jean-Baptiste Silvy 18/01/07
//    Add new axe Axe 
 
  if ~exists("with_box","local") then, with_box=%t, end
  if ~exists("font_size","local") then
    font_size = 1 ; // default size
  end

 
  if or(size(my_color)==1) then, my_color=matrix(my_color,1,-1),end
  ns=size(my_color,2)
  nleg=size(leg,'*')
  
  //preserve current graphic context
  f=gcf()
  
    //defer the drawing to avoid binking
  id=f.immediate_drawing=='on';
  if id then f.immediate_drawing=='off',end
  vis=f.immediate_drawing;
  
   // get current axes and properties
  old_ax=gca(); 
  wr=old_ax.axes_bounds; //get the rectangle of the current axes
  
  // modify the orginal axes to let space for the legend
  old_ax.axes_bounds=[wr(1) , wr(2) , 0.8*wr(3) , wr(4)]
  old_ax.margins=[old_ax.margins(1) 0.02 old_ax.margins(2:3)]
  // create a new axes for the colorbar et set its properties
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

  
  rect=xstringl(0.5,0.7,leg,a.font_style,a.font_size)
  xpol=[rect(1) rect(1)+rect(3) rect(1)+rect(3) rect(1)]
  ypol=[rect(2) rect(2) rect(2)-rect(4) rect(2)-rect(4)]
  
  if with_box then
     xpol = [0, 1, 1, 0];
     ypol = [0,0, 1, 1];     
     xfpoly(xpol, ypol,1)
     R = gce();
     R.foreground=a.foreground;
     R.background=a.background;
 end
 xset("thickness",10) 
 
  Pos_y=
 
  
  if id then f.immediate_drawing='on',end

  set('current_axes',old_ax),
  
  // if immediate_drawing was "on", then the figure will redraw itself.
  xset("thickness",1) 
  f.immediate_drawing = vis;
  sca(a_pl)

endfunction
