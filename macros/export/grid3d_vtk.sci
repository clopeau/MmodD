// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  grid3d_vtk(u,G,opt)
   [lhs,rhs]=argn(0);
   if rhs==2
     [nx,ny,nz]=size(G);
     fprintf(u,'DATASET RECTILINEAR_GRID');
     fprintf(u,'DIMENSIONS '+string(nx)+' '+string(ny)+' '+string(nz));
     fprintf(u,'X_COORDINATES '+string(nx)+' float');
     write(u,(G.x)');
     fprintf(u,'Y_COORDINATES '+string(ny)+' float');
     write(u,(G.y)');
     fprintf(u,'Z_COORDINATES '+string(nz)+' float');
     write(u,(G.z)');
   else
     nnode=size(G);
     ncell=size(G,'c');
     fprintf(u,'DATASET UNSTRUCTURED_GRID');
     fprintf(u,'POINTS '+string(nnode)+' float');
     X=ones(g.z).*.ones(g.y).*.g.x;
     Y=ones(g.z).*.g.y.*.ones(g.x);
     Z=g.z.*.ones(g.y).*.ones(g.x);
     write(u,[X,Y,Z]);
     nnc=9*ncell;
     fprintf(u,'CELLS '+string(ncell)+' '+string(nnc));
     COOR=[8*ones(ncell,1),(G([1 1 1],'c2n')-1),(G([2 1 1],'c2n')-1),...
	   (G([2 2 1],'c2n')-1),(G([1 2 1],'c2n')-1),(G([1 1 2],'c2n')-1),...
	   (G([2 1 2],'c2n')-1),(G([2 2 2],'c2n')-1),(G([1 2 2],'c2n')-1)];
     fprintf(u,'%i %i %i %i %i %i %i %i %i\n',COOR)
     fprintf(u,'CELL_TYPES '+string(ncell));
     TYPE=12*ones(ncell,1);
     write(u,string(TYPE));
   end

endfunction

