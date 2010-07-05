function [nx,ny]=%grid1d_size(%tmp,%opt)
// fonction size
// taille de la grille
// opt : noeud, face ou cellule (comme 3d)
   nx=length(%tmp.x);
   ny=nx-1;
   [lhs,rhs]=argn(0);

   if rhs==1
     %opt='node'
   end
   
   %opt=convstr(part(%opt,1),'l');
   
   if %opt=='c'
     nx=nx-1;
     return
   end
 endfunction
 
