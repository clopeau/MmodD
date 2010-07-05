function hex3d_gmv(u,G)
    // maillage structuré

   z=0;
   [np,nt]=size(G);
   nz=1;
   
   fprintf(u,'nodev '+string(np));
   write(u,G.Coor);
   fprintf(u,'cells '+string(nt));
   add='hex 8 ';
   write(u,add+strcat(string(G.Hex),' ','c'))
   
   
 endfunction
 
