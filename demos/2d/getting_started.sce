// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

tmp=lines();
lines(0)
write(%io(2),'')
write(%io(2),'')
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'       +  MmodD    Getting Started 2d      +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')
write(%io(2),'')
write(%io(2),'-->th=square2d(20,20)    \\ Mesh definition');
th=square2d(20,20);
disp(th);
write(%io(2),'')
write(%io(2),'-->meshtool(th)          \\ Mesh visualisation')
scf();
meshtool(th)
write(%io(2),'')
write(%io(2),'-->u=p1(th)              \\ Variable definition');
u=p1(th)
disp(u);
write(%io(2),'')
write(%io(2),'-->pb=pde(u)             \\ Problem definition');
pb=pde(u)
disp(pb);
write(%io(2),'')
write(%io(2),'-->pb.S=""Id(u)=1"";       \\ Boundaries conditions');
write(%io(2),'-->pb.E=""Dn(u)=y"";');
write(%io(2),'-->pb.W=""Dn(u)+Id(u)=sin(y)""');
pb.S="Id(u)=1"
pb.E="Dn(u)=y"
pb.W="Dn(u)+Id(u)=sin(y)"
disp(pb);
write(%io(2),'')
write(%io(2),'-->assemble(pb)          \\ Assembling process');
txt=assemble(pb);
disp(txt)
write(%io(2),'')
write(%io(2),'-->lsolve(pb)            \\ Linear resolution');
txt=lsolve(pb)
disp(txt)
write(%io(2),'')
write(%io(2),'-->vartool(u)            \\ Result visualisation')
scf()
vartool(u)
lines(tmp(1));
