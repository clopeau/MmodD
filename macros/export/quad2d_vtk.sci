// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function quad2d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    
    fprintf(u,'DATASET UNSTRUCTURED_GRID');
    fprintf(u,'POINTS '+string(np)+' float');
    write(u,[th.Coor zeros(np,1)]);
    fprintf(u,'CELLS '+string(nt)+' '+string(5*nt));
    trois=4;
    write(u,strcat(string([trois(ones(nt,1),:) , th.Quad-1]),' ','c'))
    fprintf(u,'CELL_TYPES '+string(nt));
    trois=9;
    write(u,string(trois(ones(nt,1),:)));
    
endfunction
  