// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function quad2d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    
    mfprintf(u,'DATASET UNSTRUCTURED_GRID\n');
    mfprintf(u,'POINTS '+string(np)+' float\n');
    mfprintf(u,'%f %f %f\n',[th.Coor zeros(np,1)]);
    mfprintf(u,'CELLS '+string(nt)+' '+string(5*nt)+'\n');
    mfprintf(u,'4 %i %i %I %i\n',th.Quad-1)
    mfprintf(u,'CELL_TYPES '+string(nt)+'\n');
    trois=9;
    mfprintf(u,string(trois(ones(nt,1),:)));
    
endfunction
  
