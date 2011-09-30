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
write(%io(2),'')
write(%io(2),'-->th=read_tri2d_NETGEN(""geom_potelec2d.vol"")   \\ Mesh import');
th=read_tri2d_NETGEN(%mmodd_path+"/demos/2d/Mesh_example/geom_potelec2d.vol");
disp(th)
write(%io(2),'')
write(%io(2),'-->meshtool(th)            \\ Mesh visualisation')
scf();
meshtool(th)
write(%io(2),'')
write(%io(2),'-->u=p1(th)              \\ Variable definition');
u=p1(th);
disp(u);
write(%io(2),'')
write(%io(2),'-->pb=pde(u)             \\ Problem definition');
pb=pde(u);
disp(pb)
write(%io(2),'')
write(%io(2),'-->k=p0(th,''0'')             \\ Conductivity definition');
write(%io(2),'-->k.Cell(th.TriId==1)=1e3');
write(%io(2),'-->k.Cell(th.TriId==2)=1e-3')
k=p0(th,'0')
k.Cell(th.TriId==1)=1e3
k.Cell(th.TriId==2)=1e-3
write(%io(2),'')
write(%io(2),'-->pb.eq=''-kLaplace(k,u)=0'';   \\ Main equation');
pb.eq='-kLaplace(k,u)=0';
write(%io(2),'')
write(%io(2),'-->pb.f1=''Id(u)=0'';            \\Boundaries conditions')
write(%io(2),'-->pb.f3=''Id(u)=10'';')
write(%io(2),'-->for i=[2 4:11]')
write(%io(2),'-->    execstr(''pb.f''+string(i)+''=""""Dn(u)=0""""'')');
write(%io(2),'-->end')
pb.f1='Id(u)=0';
pb.f3='Id(u)=10';
for i=[2 4:11];
  execstr('pb.f'+string(i)+'=""Dn(u)=0""');
end
disp(pb)
write(%io(2),'')
write(%io(2),'-->assemble(pb)          \\ Assembling process');
txt=assemble(pb)
disp(txt)
write(%io(2),'')
write(%io(2),'-->lsolve(pb)            \\ Linear resolution');
txt=lsolve(pb);
disp(txt)
scf();
write(%io(2),'')
write(%io(2),'-->vartool(u)            \\ Result visualisation')
vartool(u)
lines(tmp(1));

