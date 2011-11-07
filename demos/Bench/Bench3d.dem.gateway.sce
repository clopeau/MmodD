// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

demopath = get_absolute_file_path("Bench3d.dem.gateway.sce");
dim=3;
ext=string(dim)+'d';
vtype=['p1_']+ext
grille=['tcube3d'];

subdemolist = [ ..
    'Laplacian with homogene dirichlet boudary conditions','pb3d_1.sce';
    'Laplacian with non-homogene dirichlet boudary conditions','pb3d_2.sce';
    'Laplacian with non-homogene Neuman on Est','pb3d_3.sce';
    'Laplacian with non-homogene Neuman on West','pb3d_4.sce';
    'Laplacian with non-homogene Neuman on Nord','pb3d_5.sce';
    'Laplacian with non-homogene Neuman on Sud','pb3d_6.sce';
    'Laplacian with non-homogene Neuman on Down','pb3d_7.sce';
    'Laplacian with non-homogene Neuman on Up','pb3d_8.sce';
    'Laplacian and diffusion in x+, homogene Dirichlet','pb3d_9.sce';
    'Laplacian and diffusion in y+, homogene Dirichlet','pb3d_10.sce';
    'Laplacian and diffusion in z+, homogene Dirichlet','pb3d_11.sce';]
    
subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
