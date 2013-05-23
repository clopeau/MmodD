// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tri3d_gmv(u,G)
    // maillage structuré

   z=0;
   [np,nt]=size(G);
   nz=1;
   
   mfprintf(u,'nodev '+string(np)+'\n');
   mfprintf(u,'%f %f %f\n',G.Coor);
   mfprintf(u,'cells '+string(nt)+'\n');
   mfprintf(u,'tri 3 %i %i %i\n',G.Tri)
   
 endfunction
 
