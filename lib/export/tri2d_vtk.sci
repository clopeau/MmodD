function tri2d_vtk(u,th)
    z=0;
    [np,nt]=size(th);
    nz=1;
    
    //fprintf(u,'DATASET  UNSTRUCTURED_GRID');
    fprintf(u,'DATASET POLYDATA')
    fprintf(u,'POINTS '+string(np)+' float');
    write(u,[th.Coor zeros(np,1)]);
    //fprintf(u,'CELLS '+string(nt)+' '+string(4*nt));
    fprintf(u,'POLYGONS '+string(nt)+' '+string(4*nt));
    trois=3;
    write(u,strcat(string([trois(ones(nt,1),:) , th.Tri-1]),' ','c'))
    //fprintf(u,'CELL_TYPES '+string(nt));
    trois=5;
    //write(u,string(trois(ones(nt,1),:)));
    
endfunction
  
