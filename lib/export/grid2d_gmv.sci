function grid2d_gmv(u,G)
    // maillage structuré

   z=0;
   [nx,ny]=size(G);
   nz=1;
   fprintf(u,'nodes '+string(-1)+' '...
       +string(nx)+' '+string(ny)+' '+string(nz));
   write(u,(G.x)');
   write(u,(G.y)');
   write(u,(z)');
   fprintf(u,'cells 0');

 endfunction
 