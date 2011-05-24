// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

lines(0);
demopath = get_absolute_file_path("mesh_read.sce");
write(%io(2),'Reading BAMG file :');
filem = demopath+'Mesh_example/BAMG_octogone.msh';
write(%io(2),filem);
th_Bamg = read_tri2d_BAMG(filem);
disp(th_Bamg);

write(%io(2),'Reading 2d NETGEN file :');
filem = demopath+'Mesh_example/NETGEN_squarehole.vol';
write(%io(2),filem);
th_NETGEN = read_tri2d_NETGEN(filem);
disp(th_NETGEN);

write(%io(2),'Reading another 2d NETGEN file :');
filem = demopath+'Mesh_example/NETGEN_square2d.vol';
write(%io(2),filem);
th_NETGEN2 = read_tri2d_NETGEN(filem);
disp(th_NETGEN);
