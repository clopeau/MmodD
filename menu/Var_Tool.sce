  rac=evstr('typeof('+%_nams(%n)+')');
  
  // nouvelle fenetre
  gwin=(max(winsid())+1);
  xset('window',gwin);
   // xset('background',[0,0,245]);
  xset("wdim",800,600)
  //gwin=xget("window");
  // Menu deja existant par defaut  
  
  delmenu(gwin,'Edit') 
  delmenu(gwin,'?')
  etat=[%t];
 // menu_var_disp(gwin,etat); // affichage du Menu
  
  // Commande associe au Menu 
  View='View';
  Replot='Replot';
  
  execstr(View+'_'+string(gwin)+...
      '=[''etat(1)=~etat(1);var_disp('+%_nams(%n)+',etat);menu_var_disp(gwin,etat);'' ]');
  execstr(Replot+'_'+string(gwin)+...
	  '=''var_disp('+%_nams(%n)+',etat); menu_var_disp(gwin,etat);''');
  
  execstr('var_disp('+%_nams(%n)+',etat)')
  
  menu_var_disp(gwin,etat); // affichage du Menu