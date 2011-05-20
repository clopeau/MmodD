// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

lines(0);
global %mmodd_path
th3d=importNETGEN(%mmodd_path+"/demos/3d/cone")
u3d=p1(th3d);
pb3d=edp(u3d);
pb3d.eq="-Laplace(u3d)=x+10*z*y";
pb3d.f1="Id(u3d)=z"
pb3d.f2="Dn(u3d)=0"
pb3d.f2="Dn(u3d)+2*Id(u3d)=x+y"
assemble(pb3d)
lsolve(pb3d)
