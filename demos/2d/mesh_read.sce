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
write(%io(2),'-->\\------- BAMG Format -------')
write(%io(2),'')
write(%io(2),'-->th_Bamg = read_tri2d_BAMG(""BAMG_octogone.msh""); ');
filem = demopath+'Mesh_example/BAMG_octogone.msh';
th_Bamg = read_tri2d_BAMG(filem);
disp(th_Bamg);
write(%io(2),'')
write(%io(2),'-->meshtool(th_Bamg)            \\ Mesh visualisation')
scf()
meshtool(th_Bamg)

write(%io(2),'')
write(%io(2),'-->\\------- NETGEN Format -------')
write(%io(2),'')
write(%io(2),'-->th_NETGEN = read_tri2d_NETGEN(""NETGEN_squarehole.vol"");');
filem = demopath+'Mesh_example/NETGEN_squarehole.vol';
th_NETGEN = read_tri2d_NETGEN(filem);
disp(th_NETGEN);
write(%io(2),'')
write(%io(2),'-->meshtool(th_NETGEN)            \\ Mesh visualisation')
scf()
meshtool(th_NETGEN)

write(%io(2),'')
write(%io(2),'-->\\------- NETGEN Format -------')
write(%io(2),'')
write(%io(2),'-->th_NETGEN2 = read_tri2d_NETGEN(""NETGEN_square2d.vol"");');
filem = demopath+'Mesh_example/NETGEN_square2d.vol';
th_NETGEN2 = read_tri2d_NETGEN(filem);
disp(th_NETGEN2);
write(%io(2),'')
write(%io(2),'-->meshtool(th_NETGEN2)            \\ Mesh visualisation')
scf()
meshtool(th_NETGEN2)

write(%io(2),'')
write(%io(2),'-->\\------- GMSH Format -------')
write(%io(2),'')
write(%io(2),'-->th_GMSH = read_tri2d_GMSH(""GMSH_squarehole2d.msh"");');
filem = demopath+'Mesh_example/GMSH_squarehole2d.msh';
th_GMSH = read_tri2d_GMSH(filem);
disp(th_GMSH);
write(%io(2),'')
write(%io(2),'-->meshtool(th_GMSH)            \\ Mesh visualisation')
scf()
meshtool(th_GMSH)
lines(tmp(1));
