function tet3d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    
    fprintf(u,'DATASET UNSTRUCTURED_GRID\n');
    fprintf(u,'POINTS %i float\n',np);
    fprintf(u,'%3.12f %3.12f %3.12f\n',th.Coor);
    fprintf(u,'CELLS %i %i\n',nt,5*nt);
    trois=4;
    //Tet=th.Tet-1;
    fprintf(u,'4 %i %i %i %i\n',th.Tet-1)
    //write(u,strcat(string([trois(ones(nt,1)),th.Tet-1]),' ','c'));
    fprintf(u,'CELL_TYPES %i\n',nt);
    trois=10;
    fprintf(u,'%i\n',trois(ones(nt,1)));
    
endfunction
  
