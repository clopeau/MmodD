// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tet3d_gmv(u,G)
    // maillage structuré

   [np,nt]=size(G);
   
   mfprintf(u,'nodev '+string(np)+'\n');
   write(u,G.Coor);
   mfprintf(u,'cells '+string(nt)+'\n');
   add='tet 4 ';
   write(u,add+strcat(string(G.Tet),' ','c'))
   
 endfunction
 
