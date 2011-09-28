// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

tmp=lines();
lines(0);
global %mmodd_path
write(%io(2),'')
write(%io(2),'')
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'       +  MmodD    Square with hole 2d     +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')
write(%io(2),'')
write(%io(2),'-->th2d=read_tri2d_NETGEN(""NETGEN_squarehole.vol"")   \\ Mesh import');
th2d=read_tri2d_NETGEN(%mmodd_path+"/demos/2d/Mesh_example/NETGEN_squarehole.vol")
disp(th2d)
write(%io(2),'')
write(%io(2),'-->meshtool(th2d)            \\ Mesh visualisation')
scf()
meshtool(th2d)
write(%io(2),'')
write(%io(2),'-->u2d=p1(th2d)              \\ Variable definition');
u2d=p1(th2d);
disp(u2d)
write(%io(2),'')
write(%io(2),'-->pb2d=pde(u2d)             \\ Problem definition');
pb2d=pde(u2d);
disp(pb2d);
write(%io(2),'')
write(%io(2),'-->pb2d.eq=""-Laplace(u2d)+Dx(u2d)=x+10*y"";  \\Main equation');
write(%io(2),'-->pb2d.f1=""Id(u2d)=y"";                     \\Boundaries conditions');
write(%io(2),'-->pb2d.f2=""Dn(u2d)+2*Id(u2d)=x+y""')
pb2d.eq="-Laplace(u2d)+Dx(u2d)=x+10*y";
pb2d.f1="Id(u2d)=y"
pb2d.f2="Dn(u2d)+2*Id(u2d)=x+y"
disp(pb2d)
write(%io(2),'')
write(%io(2),'-->assemble(pb2d)          \\ Assembling process');
txt=assemble(pb2d)
disp(txt)
write(%io(2),'')
write(%io(2),'-->lsolve(pb2d)            \\ Linear resolution');
txt=lsolve(pb2d)
disp(txt)
scf()
write(%io(2),'')
write(%io(2),'-->vartool(u2d)            \\ Result visualisation')
vartool(u2d)
lines(tmp(1));
