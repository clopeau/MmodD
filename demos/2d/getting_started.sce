// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// mesh definition
write(%io(2),'')
write(%io(2),'')
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'       +         Getting Started 2d        +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')

// mesh definition
write(%io(2),'')
write(%io(2),'-->th=square2d(12,13)    \\ Mesh definition');
th=square2d(12,13);
disp(th);
write(%io(2),'')
write(%io(2),'-->meshtool(th)          \\ Mesh visualisation')
scf();
meshtool(th)
write(%io(2),'')
write(%io(2),'-->u=p1_2d(th)           \\ Variable definition');
u=p1_2d(th)
disp(u);
write(%io(2),'')
write(%io(2),'-->pb=pde(u)             \\ Problem definition');
pb=pde(u)
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
