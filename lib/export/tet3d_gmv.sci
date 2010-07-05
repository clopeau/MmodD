function tet3d_gmv(u,G)
    // maillage structuré

   [np,nt]=size(G);
   
   fprintf(u,'nodev '+string(np));
   write(u,G.Coor);
   fprintf(u,'cells '+string(nt));
   add='tet 4 ';
   write(u,add+strcat(string(G.Tet),' ','c'))
   
 endfunction
 
