// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 
tmp=lines();
lines(0);
demopath = get_absolute_file_path("mesh_read.sce");
write(%io(2),'')
write(%io(2),'')
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'       +  MmodD        2d mesh format      +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')
write(%io(2),'-->\\------- NETGEN Format -------');
write(%io(2),'')
write(%io(2),'-->th_NETGEN = read_tet3d_NETGEN(""NETGEN_cone.vol"")');
filem = demopath+'Mesh_example/NETGEN_cone.vol';
th_NETGEN = read_tet3d_NETGEN(filem);
disp(th_NETGEN);
write(%io(2),'')
write(%io(2),'-->meshtool(th_NETGEN)            \\ Mesh visualisation')
meshtool(th_NETGEN)
xtitle('NETGEN')

write(%io(2),'')
write(%io(2),'-->\\------- TETGEN Format -------');
write(%io(2),'')
write(%io(2),'-->th_TETGEN = read_tet3d_TETGEN(""TETGEN_codecasa.1"")');
filem = demopath+'Mesh_example/TETGEN_codecasa.1';
th_TETGEN = read_tet3d_TETGEN(filem);
disp(th_TETGEN);
write(%io(2),'')
write(%io(2),'-->meshtool(th_TETGEN)            \\ Mesh visualisation')
meshtool(th_TETGEN)
xtitle('TETGEN')

write(%io(2),'')
write(%io(2),'-->\\------- GMSH Format -------')
write(%io(2),'')
write(%io(2),'-->th_GMSH = read_tet3d_GMSH(""GMSH_cube.msh"")')
filem = demopath+'Mesh_example/GMSH_cube.msh';
th_GMSH = read_tet3d_GMSH(filem);
disp(th_GMSH);
write(%io(2),'')
write(%io(2),'-->meshtool(th_GMSH)            \\ Mesh visualisation')
meshtool(th_GMSH)
xtitle('GMSH')

lines(tmp(1));
