// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

lines(0);
demopath = get_absolute_file_path("mesh_read.sce");
write(%io(2),'Reading NETGEN file :');
filem = demopath+'Mesh_example/NETGEN_cone.vol';
write(%io(2),filem);
th_NETGEN = read_tet3d_NETGEN(filem);
disp(th_NETGEN);

write(%io(2),'Reading TETGEN file :');
filem = demopath+'Mesh_example/TETGEN_codecasa.1';
th_TETGEN = read_tet3d_TETGEN(filem);
disp(th_TETGEN);
