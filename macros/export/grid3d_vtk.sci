// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  grid3d_vtk(u,G,opt)
   [lhs,rhs]=argn(0);
   if rhs==2
     [nx,ny,nz]=size(G);
     mfprintf(u,'DATASET RECTILINEAR_GRID\n');
     mfprintf(u,'DIMENSIONS '+string(nx)+' '+string(ny)+' '+string(nz)+'\n');
     mfprintf(u,'X_COORDINATES '+string(nx)+' float\n');
     mfprintf(u,'%f\n',(G.x)');
     mfprintf(u,'Y_COORDINATES '+string(ny)+' float\n');
     mfprintf(u,'%f\n',(G.y)');
     mfprintf(u,'Z_COORDINATES '+string(nz)+' float\n');
     mfprintf(u,'%f\n',(G.z)');
   else
     nnode=size(G);
     ncell=size(G,'c');
     mfprintf(u,'DATASET UNSTRUCTURED_GRID\n');
     mfprintf(u,'POINTS '+string(nnode)+' float\n');
     X=ones(g.z).*.ones(g.y).*.g.x;
     Y=ones(g.z).*.g.y.*.ones(g.x);
     Z=g.z.*.ones(g.y).*.ones(g.x);
     mfprintf(u,,'%f %f %f\n',[X,Y,Z]);
     nnc=9*ncell;
     mfprintf(u,'CELLS '+string(ncell)+' '+string(nnc)+'\n');
     COOR=[8*ones(ncell,1),(G([1 1 1],'c2n')-1),(G([2 1 1],'c2n')-1),...
	   (G([2 2 1],'c2n')-1),(G([1 2 1],'c2n')-1),(G([1 1 2],'c2n')-1),...
	   (G([2 1 2],'c2n')-1),(G([2 2 2],'c2n')-1),(G([1 2 2],'c2n')-1)];
     mfprintf(u,'%i %i %i %i %i %i %i %i %i\n',COOR)
     mfprintf(u,'CELL_TYPES '+string(ncell)+'\n');
     TYPE=12*ones(ncell,1);
     mfprinyf(u,string(TYPE)+'\n');
   end

endfunction

