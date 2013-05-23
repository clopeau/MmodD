// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tet3d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    
    mfprintf(u,'DATASET UNSTRUCTURED_GRID\n');
    mfprintf(u,'POINTS %i float\n',np);
    mfprintf(u,'%3.12f %3.12f %3.12f\n',th.Coor);
    mfprintf(u,'CELLS %i %i\n',nt,5*nt);
    mfprintf(u,'4 %i %i %i %i\n',th.Tet-1)
    mfprintf(u,'CELL_TYPES %i\n',nt);
    trois=10;
    mfprintf(u,'%i\n',trois(ones(nt,1)));
    
endfunction
  
