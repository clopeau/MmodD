f=figure();
   delmenu('Fichier')
   delmenu('Outils')
   delmenu('Edition')
   delmenu('?')
   etat=[%f;%f;%f;%t;%t;%f]; // etat d'affichage :voir node, triangles et extremes
 
   mmesh=uimenu(f,'label', 'Mesh');
   mplot=uimenu(f,'label','Plot');
  
 // create an item on the menu bar
 mmesh1=uimenu(mmesh,'label', 'New Mesh','callback','th=square2d(10,10);' );
 mplot1=uimenu(mplot,'label','Plot",'callback','call(funcallbackaff(gcf(),th,etat))');
 //mplot1=uimenu(mplot,'label', 'Replot','callback','mesh_disp(th)'+';'+ 'menu_mesh_disp(f)');
 
 function [] = funcallbackaff(f,th,etat)
   mesh_disp(th)
   menu_mesh_disp(f,etat)
  endfunction
 
