// Copyright (C) 2010-11 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//<-- NO CHECK REF -->

meshgeo=square2d(50,50);
u=p1(meshgeo);
pb=pde(u);
pb.eq='-Laplace(u)=8*%pi^2*cos(2*%pi*x)*cos(2*%pi*y)';
pb.S='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
pb.N='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
pb.E='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
pb.W='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
u_ex=p1(meshgeo,'cos(2*%pi*x)*cos(2*%pi*y)');
assemble(pb);
lsolve(pb);
if max(abs(u-u_ex)) > 0.0056 then pause, end
 