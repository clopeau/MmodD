  rac=evstr('typeof('+%_nams(%n)+')');
  
  // nouvelle fenetre
  gwin=(max(winsid())+1);
  xset('window',gwin);
  //gwin=xget("window");
  // Menu deja existant par defaut  
  
  delmenu(gwin,'Edit') 
  
  etat=[%t];
  menu_var_disp(gwin,etat); // affichage du Menu
  
  // Commande associe au Menu 
  View='View';
  Replot='Replot';
  execstr(View+'_'+string(gwin)+...
      '=[''etat(1)=~etat(1); menu_var_disp(gwin,etat); var_disp('+%_nams(%n)+',etat)'' ]');
  execstr(Replot+'_'+string(gwin)+...
	  '=''var_disp('+%_nams(%n)+',etat)''');

  execstr('var_disp('+%_nams(%n)+',etat)')
