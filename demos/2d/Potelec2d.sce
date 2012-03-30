// Copyright (C) 2011 - Mylène Baudoin
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
write(%io(2),'       +  MmodD   Electric potential 2d    +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')
write(%io(2),'')

stacksize('max')
//  Mesh import
th=read_tri2d_NETGEN(%mmodd_path+"/demos/2d/Mesh_example/geom_potelec2d.vol");
disp(th)
// Mesh visualisation
meshtool(th)
// FE definition
u=p1(th);
disp(u);
// Problem definition');
pb=pde(u);
disp(pb)
// Conductivity definition
k=p0(th,'0')
k.Cell(th.TriId==1)=1e3
k.Cell(th.TriId==2)=1e-3
// Main equation
pb.eq='-kLaplace(k,u)=0';
// Boundaries conditions
pb.f1='Id(u)=0';
pb.f3='Id(u)=10';
for i=[2 4:11];
  execstr('pb.f'+string(i)+'=""Dn(u)=0""');
end
disp(pb)
// Assembling process
txt=assemble(pb)
disp(txt)
// Linear resolution
txt=lsolve(pb);
disp(txt)
//  Result visualisation')
vartool(u)
lines(tmp(1));

