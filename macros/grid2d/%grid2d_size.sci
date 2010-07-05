function [nx,ny]=%grid2d_size(G,opt)
// fonction size
// taille de la grille
// opt : noeud, face ou cellule (comme 3d)
   
   nx=length(G.x);
   ny=length(G.y);
   [lhs,rhs]=argn(0);

   if rhs==1
     opt='node'
   end
   
   opt=convstr(part(opt,1),'l');
   n=0;c=-1;
   
   if opt=='a'
     nfx=(ny-1)*nx;
     nfy=(nx-1)*ny;
     nx=nfx;
     ny=nfy;
     if lhs==1
       nx=nx+ny;
     end
     return
   elseif opt=='c'
     nx=nx-1;
     ny=ny-1;
     if lhs==1
       nx=nx*ny;
     end
     return
   elseif opt=='f'
     nfx=0;
     nfy=0;
     nfz=(nx-1)*(ny-1);
     if lhs==1
       nx=(nx-1)*(ny-1);
     end
     return
   end
   if lhs==1
     nx=nx*ny;
   end
 
 endfunction
 
