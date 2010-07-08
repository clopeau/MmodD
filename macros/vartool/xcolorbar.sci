function [gwin]=xcolorbar(zmin,zmax)
// fonction d'affichage de la barre des couleurs
// dans une fenêtre separe
// Procedure qui fonctionne correctement sous 2.7
// renvoit le numero de fenetre correspondant
   coulmax=256;
   l=winsid();
   if l==[]
     l=-1;
   end
   gwin=l($)+1;
   //xset("wresize",1);
   xset('window',gwin);
   xset('wpdim',105,350);
   xset('wdim',70,300);
   clf();
   delmenu(gwin,'Zoom')
   delmenu(gwin,'2D Zoom') // Scilab2.6
   delmenu(gwin,'UnZoom')
   delmenu(gwin,'3D Rot.')
   //delmenu(gwin,'File')
   //addmenu(gwin,'Close',list(0,'del('+string(gwin)+')'));
   //th=square2d(2,2);
   //bar=interpol(th,'coulmax*y','p1');
   xsetech(frect=[0 0 1 1],arect=[1/5 1/2 1/10 0])
   //var_plot(th,bar)
   
   nval=8;
   z=linspace(zmin,zmax,nval)
   
   for i=1:nval
     xstring(1.1,(i-1)/(nval-1),string(z(i)))
     xsegs([1 ;1.05],(i-1)/(nval-1)*[1 ;1],int(coulmax*(i-1)/(nval-1)))
   end
   xset('window',l($))
   
endfunction
