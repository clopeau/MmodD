// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function hex3d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    
    mfprintf(u,'DATASET UNSTRUCTURED_GRID\n');
    mfprintf(u,'POINTS '+string(np)+' float\n');
    mfprintf(u,'%g %g %g\n',th.Coor);
    mfprintf(u,'CELLS '+string(nt)+' '+string(9*nt)+'\n');
    //trois=8;
    //write(u,strcat(string([trois(ones(nt,1),:) , th.Hex-1]),' ','c'))
    mfprintf(u,"8 %i %i %i %i %i %i %i %i\n",th.Hex-1);
    mfprintf(u,'CELL_TYPES '+string(nt)+'\n');
    trois=12;
    write(u,string(trois(ones(nt,1),:)));
    //fprintf(u,"12\n",ones(nt,1));
    
endfunction
  
