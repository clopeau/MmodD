// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tri2d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    mfprintf(u,'DATASET POLYDATA\n')
    mfprintf(u,'POINTS '+string(np)+' float\n');
    mfprintf(u,'%f %f %f\n',[th.Coor zeros(np,1)]);
    mfprintf(u,'POLYGONS '+string(nt)+' '+string(4*nt)+'\n');
    mfprintf(u,'3 %i %i %i\n',th.Tri-1)
    
endfunction
  
