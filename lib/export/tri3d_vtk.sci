function tri3d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    fprintf(u,'DATASET UNSTRUCTURED_GRID\n');
    fprintf(u,'POINTS %i float\n',np);
    fprintf(u,'%g %g %g\n',th.Coor);
    fprintf(u,'CELLS %i %i\n',nt,4*nt);
    trois=3;
    //Tet=th.Tet-1;
    //fprintf(u,'%i %i %i %i %i\n',[trois(ones(nt,1),:),th.Tri-1])
    write(u,strcat(string([trois(ones(nt,1),:),th.Tri-1]),' ','c'));
    fprintf(u,'CELL_TYPES %i\n',nt);
    trois=5;
    fprintf(u,'%i\n',trois(ones(nt,1)));
endfunction
  
