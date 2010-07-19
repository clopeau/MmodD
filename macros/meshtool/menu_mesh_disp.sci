function []=menu_mesh_disp(gwin,etat)

  Number='Number';
  subNumb=['Show Node';'Show Cell';'Show Face'];
  Geom='Geom';
  subGeom=['unShow Cell';'Show Boundary';'Show Extrem']
  Replot='Reset';
  Exit='Exit';
 
  
  delmenu(gwin,Number);
  delmenu(gwin,Geom);
  delmenu(gwin,Replot);
  delmenu(gwin,Exit);
  
  if etat(1) then subNumb(1)='UnShow Node', end
  if etat(2) then subNumb(2)='UnShow Cell', end
  if etat(3) then subNumb(3)='UnShow Face', end
  if ~etat(4) then subGeom(1)='Show Cell', end
  if etat(5) then subGeom(2)='UnShow Boundary', end
  if etat(6) then subGeom(3)='UnShow Extrem', end
  
  addmenu(gwin,Number,subNumb)
  addmenu(gwin,Geom,subGeom)
  addmenu(gwin,Replot)
  //addmenu(gwin,Exit)
  
endfunction
