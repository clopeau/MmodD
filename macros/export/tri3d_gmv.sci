// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tri3d_gmv(u,G)
    // maillage structur�

   z=0;
   [np,nt]=size(G);
   nz=1;
   
   mfprintf(u,'nodev '+string(np)+'\n');
   write(u,[G.Coor]);
   mfprintf(u,'cells '+string(nt)+'\n');
   add='tri 3 ';
   write(u,add+strcat(string(G.Tri),' ','c'))
   
   
 endfunction
 
