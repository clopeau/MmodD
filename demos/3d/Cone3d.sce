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
write(%io(2),'       +    MmodD   Truncated Cone 3d      +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')
// Mesh definition
th3d=read_tet3d_NETGEN(%mmodd_path+"/demos/3d/Mesh_example/NETGEN_cone.vol");
disp(th3d);
// Mesh visualisation
meshtool(th3d)
// Variable definition
u3d=p1(th3d);
disp(u3d);
// Problem definition
pb3d=pde(u3d);
// Main equation
pb3d.eq="-Laplace(u3d)=x+10*z*y";
pb3d.f1="Id(u3d)=z"
pb3d.f2="Dn(u3d)=0"
pb3d.f2="Dn(u3d)+2*Id(u3d)=x+y"
disp(pb3d)
// Assembling process
txt=assemble(pb3d);
disp(txt)
// Linear resolution
txt=lsolve(pb3d)
disp(txt)
// Result visualisation
vartool(u3d)


lines(tmp(1));
