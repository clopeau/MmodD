function []=vartool(var)
 
  //-------------------- Gestion des menus -----------------------
  View='View';
  Replot='Replot';
  Exit='Exit';
  gwin=(max(winsid())+1)
  xset('window',gwin);
  gwin=xget("window");
  
  etat=[%t];

  menu_var_disp(gwin,etat); // affichage du Menu

  // Commande associe au Menu vartool
  execstr('global '+View+'_'+string(gwin));
  execstr(View+'_'+string(gwin)+...
	  '=[''etat(1)=~etat(1); menu_var_disp(gwin,etat); var_disp(var,etat)'' ]');
  
  // Commande associe au Replot
   execstr('global '+Replot+'_'+string(gwin));
   execstr(Replot+'_'+string(gwin)+...
	  '=''var_disp(var,etat)''');
   
   // Commande associe au Exit
   execstr('global '+Exit+'_'+string(gwin));
   execstr(Exit+'_'+string(gwin)+...
	  '=''delmenu(gwin,View  );'+...
	  'delmenu(gwin,Replot);'+...
	  'delmenu(gwin,Exit);'+...
	  'Vartool_stop=%t;''');
  
      
   //---------------------- Affichage et boucle infinie -------------------
 
   rac=typeof(var)
    
  
   xbasc();
   rect =evstr('[min('+var.geo+');max('+var.geo+')]');
   minmax =[min(var);max(var)]
   plot2d(1,1,[1],"030"," ",rect(1:4));
  
 
  var_disp(var,etat); // afficher suivant la var etat
  Vartool_stop=%f
  while ~Vartool_stop
    //getclick() // attention commande non commente
    xpause(10000) //pour ne pas avoir de temps cpu inutilement utilise
  end
endfunction

 
