function [] = menu()
  f=gcf();
  mmesh=uimenu(f,'label', 'Mesh');
   mplot=uimenu(f,'label','Plot');
  
 // create an item on the menu bar
   mmesh1=uimenu(mmesh,'label', 'New Mesh','callback','call(th=funcallbackel())' );
    mplot1=uimenu(mplot,'label','Plot",'callback','call(funcallbackaff(gcf(),th,etat))');
  endfunction
  
 function [] = funcallbackaff(f,th,etat)
   mesh_disp(th)
   menu()
  endfunction
 
 function [th] = funcallbackel(th,nx,ny)
   clear th
   txt = ['number node x';'number node y'];
   sig = x_mdialog('enter parameter of triangulation',txt,['10';'10'])
   nx=evstr(sig(1))
   ny=evstr(sig(2))
   th=square2d(nx,ny)
   return(th)
 endfunction
 
f=figure();
   etat=[%f;%f;%f;%t;%t;%f]; // etat d'affichage :voir node, triangles et extremes
call(menu())
   


