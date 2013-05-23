// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function quad2d_gmv(u,G)
    // maillage structuré

   z=0;
   [np,nt]=size(G);
   nz=1;
   
   mfprintf(u,'nodev '+string(np)+'\n');
   write(u,[G.Coor zeros(np,1)]);
   mfprintf(u,'cells '+string(nt)+'\n');
   add='quad 4 ';
   write(u,add+strcat(string(G.Quad),' ','c'))
   
   
 endfunction
 
