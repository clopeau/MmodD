function [nx,ny,nz]=%grid3d_size(G,opt)
// fonction size
// taille de la grille
// opt : noeud, face ou cellule (comme 3d)
   
   nx=length(G.x);
   ny=length(G.y);
   nz=length(G.z);
   [lhs,rhs]=argn(0);

   if rhs==1
     opt='node'
   end
   
   opt=convstr(part(opt,1),'l');
   n=0;c=-1;
   
   if opt=='f'
     nfx=nx*(ny-1)*(nz-1);
     nfy=(nx-1)*ny*(nz-1);
     nfz=(nx-1)*(ny-1)*nz;
     if lhs==1
       nx=nfx+nfy+nfz;
     else
       nx=nfx;
       ny=nfy;
       nz=nfz;
     end
     return
   elseif opt=='a'
     nax=((nx-1)*ny+(ny-1)*nx)*nz;
     nay=((ny-1)*nz+ny*(nz-1))*nx;
     naz=((nz-1)*nx+(nx-1)*nz)*ny;
     if lhs==1
       nx=nax+nay+naz;
     else
       nx=nax;
       ny=nay;
       nz=naz;
     end
     return
   else
     nx=nx+evstr(opt);
     ny=ny+evstr(opt);
     nz=nz+evstr(opt);
     
     if lhs==1
       nx=nx*ny*nz;
     end
   end
 endfunction
