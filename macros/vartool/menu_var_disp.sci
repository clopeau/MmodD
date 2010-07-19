function []=menu_var_disp(gwin,etat)

  View='View';
  subView=['3d'];
  Replot='Reset';
//  Exit='Exit';
  
  delmenu(gwin,View);
  delmenu(gwin,Replot);
//  delmenu(gwin,Exit);
  
  if ~etat(1) then subView(1)='2d', end
  
  addmenu(gwin,View,subView)
  addmenu(gwin,Replot)
//  addmenu(gwin,Exit)
  
endfunction