//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// gestion du menu meshtools
function []=mesh_disp(th,etat)
  xbasc();
  rect =[min(th)-0.05*abs(max(th)-min(th));max(th)+0.05*abs(max(th)-min(th))]';
  
  plot2d(1,1,[1],"030"," ",rect(1:4));
  
  
  if etat(4) then execstr(rac+'_plot(th)'), end
  if etat(5) then execstr(rac+'_show_bnd(th)'), end
  if etat(1) then execstr(rac+'_show_node(th)'), end
  if etat(2) then execstr(rac+'_show_cell(th)'), end
  if etat(3) then execstr(rac+'_show_face(th)'), end
  if etat(6) then execstr(rac+'_show_rect(th)'), end

endfunction

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function []=menu_mesh_disp(gwin,etat)

  Number='Number';
  subNumb=['Show Node';'Show Cell';'Show Face'];
  Geom='Geom';
  subGeom=['unShow Cell';'Show Boundary';'Show Extrem']
  Replot='Replot';
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

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function []=meshtool(th)

  rac=typeof(th)
  
  Number='Number';
  Geom='Geom';
  Replot='Replot';
  Exit='Exit';
  File='File';
  troisD='3D Rot.'
  // nouvelle fenetre
  //gwin=(max(winsid())+1);
  //xset('window',gwin);
  gwin=xget("window");
  // Menu deja existant par defaut  
  //delmenu(gwin,'3D Rot.') //2d seulement
  //unsetmenu(gwin,'File',7) //close'=Objects')
  
  etat=[%f;%f;%f;%t;%f;%f]; // etat d'affichage :voir node, triangles et extremes
  
  menu_mesh_disp(gwin,etat); // affichage du Menu

  // Commande associe au Menu Meshtool
  execstr('global '+Number+'_'+string(gwin));
  execstr(Number+'_'+string(gwin)+...
	  '=[''etat(1)=~etat(1); if etat(1) then, '+rac+'_show_node(th) ,end;... 
	  menu_mesh_disp(gwin,etat)'';...
	  ''etat(2)=~etat(2); if etat(2) then, '+rac+'_show_cell(th) ,end;... 
	  menu_mesh_disp(gwin,etat)'';...
	  ''etat(3)=~etat(3); if etat(3) then, '+rac+'_show_face(th) ,end;...  
	  menu_mesh_disp(gwin,etat)'']');
  
  // Commandes associes a Geom
  execstr('global '+Geom+'_'+string(gwin));
  execstr(Geom+'_'+string(gwin)+...
          '=[''etat(4)=~etat(4); if etat(4) then, '+rac+'_plot(th) ,end;...  
	  menu_mesh_disp(gwin,etat)'';...
	  ''etat(5)=~etat(5); if etat(5) then, '+rac+'_show_bnd(th) ,end;...  
	  menu_mesh_disp(gwin,etat)'';...
	  ''etat(6)=~etat(6); if etat(6) then, '+rac+'_show_rect(th) ,end;...  
	  menu_mesh_disp(gwin,etat)'']')
  // Commande associe au Replot
   execstr('global '+Replot+'_'+string(gwin));
   execstr(Replot+'_'+string(gwin)+...
	  '=''mesh_disp(th,etat)''');
   
   // Commande associe au Exit
   //execstr('global '+Exit+'_'+string(gwin));
   //execstr(Exit+'_'+string(gwin)+...
	//  '=''delmenu(gwin,Number);'+...
	  //'delmenu(gwin,Geom);'+...
	  //'delmenu(gwin,Replot);'+...
	  //'delmenu(gwin,Exit);'+...
	  //'Meshtool_stop=%t;''');
  // boucle infinie

  mesh_disp(th,etat); // afficher suivant la var etat
  Meshtool_stop=%f
  while ~Meshtool_stop
    //getclick() // attention commande non commente
    xpause(10000) //pour ne pas avoir de temps cpu inutilement utilise
  end
endfunction

function []=Edit(th);
   meshtool(th);
endfunction
 
