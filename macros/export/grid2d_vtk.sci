function  grid2d_vtk(u,G)
   [nx,ny]=size(G);
   nz=1;z=0;
   fprintf(u,'DATASET RECTILINEAR_GRID');
   fprintf(u,'DIMENSIONS '+string(nx)+' '+string(ny)+' '+string(nz));
   fprintf(u,'X_COORDINATES '+string(nx)+' float');
   write(u,(G.x)');
   fprintf(u,'Y_COORDINATES '+string(ny)+' float');
   write(u,(G.y)');
   fprintf(u,'Z_COORDINATES '+string(nz)+' float');
   write(u,z);
   
endfunction

