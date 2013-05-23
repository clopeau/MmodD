// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tri3d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    mfprintf(u,'DATASET UNSTRUCTURED_GRID\n');
    mfprintf(u,'POINTS %i float\n',np);
    mfprintf(u,'%g %g %g\n',th.Coor);
    mfprintf(u,'CELLS %i %i\n',nt,4*nt);
    trois=3;
    //Tet=th.Tet-1;
    mfprintf(u,'3 %i %i %i\n',th.Tri-1);
    mfprintf(u,'CELL_TYPES %i\n',nt);
    trois=5;
    mfprintf(u,'%i\n',trois(ones(nt,1)));
endfunction
  
