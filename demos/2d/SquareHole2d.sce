// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

lines(0);
global %mmodd_path
th2d=read_tri2d_NETGEN(%mmodd_path+"/demos/2d/Mesh_example/NETGEN_squarehole.vol")
u2d=p1(th2d);
pb2d=pde(u2d);
pb2d.eq="-Laplace(u2d)=x+10*y";
pb2d.f1="Id(u2d)=y"
pb2d.f2="Dn(u2d)=0"
pb2d.f2="Dn(u2d)+2*Id(u2d)=x+y"
assemble(pb2d)
lsolve(pb2d)
