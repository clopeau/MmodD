// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function grid2d_gmv(u,G)
    // maillage structuré

   z=0;
   [nx,ny]=size(G);
   nz=1;
   mfprintf(u,'nodes '+string(-1)+' '...
       +string(nx)+' '+string(ny)+' '+string(nz)+'\n');
   mfprintf(u,'%f\n',(G.x)');
   mfprintf(u,'%f\n',(G.y)');
    mfprintf(u,'%f\n',(z)');
   mfprintf(u,'cells 0\n');

 endfunction
 
