// Copyright (C) 2012 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

test=square2d(30,30);
var=p1(test);
f =p1(test,'sin(2*%pi*x)*sin(2*%pi*y)');
fcs=p1(test,'cos(2*%pi*x)*sin(2*%pi*y)');
fsc=p1(test,'sin(2*%pi*x)*cos(2*%pi*y)');
fcc=p1(test,'cos(2*%pi*x)*cos(2*%pi*y)');
//
pb=pde(var);
pb.eq='-Laplace(var)=(8*%pi^2)*f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.014 then pause, end
//
pb=pde(var);
pb.eq='-Dxx(var)-Dyy(var)=(8*%pi^2)*f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.014 then pause, end
//
pb=pde(var);
pb.eq='-Laplace(var)+Id(var)=(8*%pi^2)*f+f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.014 then pause, end
//
pb=pde(var);
pb.eq='-Laplace(var)+Dx(var)=(8*%pi^2)*f+2*%pi*fcs';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.014 then pause, end
//
pb=pde(var);
pb.eq='-Laplace(var)+Dy(var)=(8*%pi^2)*f+2*%pi*fsc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.014 then pause, end
//
pb=pde(var);
pb.eq='-Laplace(var)+Dxy(var)=(8*%pi^2)*f+4*%pi^2*fcc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.01 then pause, end
//
pb=pde(var);
pb.eq='-Laplace(var)+Dyx(var)=(8*%pi^2)*f+4*%pi^2*fcc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.01 then pause, end
//
k=p1(test,'1+x');
//
pb=pde(var);
pb.eq='-Laplace(var)+kId(k,var)=(8*%pi^2)*f+k*f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.014 then pause, end
//
pb=pde(var);
pb.eq='-kLaplace(k,var)=k*(8*%pi^2)*f-2*%pi*fcs';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.0145 then pause, end
