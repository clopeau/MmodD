// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function tet3d_gmv(u,G)
    // maillage structuré

   [np,nt]=size(G);
   
   mfprintf(u,'nodev '+string(np)+'\n');
   mfprintf(u,'%f %f %f\n',G.Coor);
   mfprintf(u,'cells '+string(nt)+'\n');
   mfprintf(u,'tet 4 %i %i %i %i\n',G.Tet)
   
 endfunction
 
