// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

demopath = get_absolute_file_path("Bench2d.dem.gateway.sce");
dim=2;
ext=string(dim)+'d';
vtype=['p1_']+ext
grille=['square2d'];


subdemolist = [ ..
   'Laplacian with homogene dirichlet boundary conditions','pb2d_1.sce';
   'Laplacian with non-homogene dirichlet boundary conditions','pb2d_2.sce';
   'Laplacian with non-homogene Neuman on Est','pb2d_3.sce';
   'Laplacian with non-homogene Neuman on West','pb2d_4.sce';
   'Laplacian with non-homogene Neuman on Nord','pb2d_5.sce';
   'Laplacian with non-homogene Neuman on Sud','pb2d_6.sce';
   'Laplacian and diffusion in x+, homogene Dirichlet','pb2dCov_7.sce';
   'Laplacian and diffusion in y+, homogene Dirichlet','pb2dCov_8.sce']
    
subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
