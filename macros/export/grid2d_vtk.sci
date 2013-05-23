// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  grid2d_vtk(u,G)
   [nx,ny]=size(G);
   nz=1;z=0;
   mfprintf(u,'DATASET RECTILINEAR_GRID\n');
   mfprintf(u,'DIMENSIONS '+string(nx)+' '+string(ny)+' '+string(nz)+'\n');
   mfprintf(u,'X_COORDINATES '+string(nx)+' float\n');
   mfprintf(u,'%f\n',(G.x)');
   mfprintf(u,'Y_COORDINATES '+string(ny)+' float\n');
   mfprintf(u,'%f\n',(G.y)');
   mfprintf(u,'Z_COORDINATES '+string(nz)+' float\n');
   mfprintf(u,'%f\n',z);
   
endfunction

