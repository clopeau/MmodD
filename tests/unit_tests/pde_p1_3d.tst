// Copyright (C) 2012 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//<-- NO CHECK REF -->

stacksize('max')
test=tcube3d(20,20,20);
var=p1(test);
f =p1(test,'sin(2*%pi*x)*sin(2*%pi*y)*sin(2*%pi*z)');
fcss=p1(test,'cos(2*%pi*x)*sin(2*%pi*y)*sin(2*%pi*z)');
fscs=p1(test,'sin(2*%pi*x)*cos(2*%pi*y)*sin(2*%pi*z)');
fssc=p1(test,'sin(2*%pi*x)*sin(2*%pi*y)*cos(2*%pi*z)');
fccs=p1(test,'cos(2*%pi*x)*cos(2*%pi*y)*sin(2*%pi*z)');
fcsc=p1(test,'cos(2*%pi*x)*sin(2*%pi*y)*cos(2*%pi*z)');
fscc=p1(test,'sin(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)');
//----- Laplace
pb=pde(var);
pb.eq='-Laplace(var)=(12*%pi^2)*f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.045 then pause, end
//----- Dxx Dyy Dzz
pb=pde(var);
pb.eq='-Dxx(var)-Dyy(var)-Dzz(var)=(12*%pi^2)*f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.045 then pause, end
//------ Id
pb=pde(var);
pb.eq='-Laplace(var)+Id(var)=(12*%pi^2)*f+f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.045 then pause, end
//------- Dx
pb=pde(var);
pb.eq='-Laplace(var)+Dx(var)=(12*%pi^2)*f+2*%pi*fcss';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.046 then pause, end
//------- Dy
pb=pde(var);
pb.eq='-Laplace(var)+Dy(var)=(12*%pi^2)*f+2*%pi*fscs';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.046 then pause, end
//------- Dz
pb=pde(var);
pb.eq='-Laplace(var)+Dz(var)=(12*%pi^2)*f+2*%pi*fssc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.046 then pause, end
//------- Dxy
pb=pde(var);
pb.eq='-Laplace(var)+Dxy(var)=(12*%pi^2)*f+4*%pi^2*fccs';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.055 then pause, end
//------- Dyx
pb=pde(var);
pb.eq='-Laplace(var)+Dyx(var)=(12*%pi^2)*f+4*%pi^2*fccs';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.055 then pause, end
//------- Dxz
pb=pde(var);
pb.eq='-Laplace(var)+Dxz(var)=(12*%pi^2)*f+4*%pi^2*fcsc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.055 then pause, end
//------- Dzx
pb=pde(var);
pb.eq='-Laplace(var)+Dzx(var)=(12*%pi^2)*f+4*%pi^2*fcsc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.055 then pause, end
//------- Dyz
pb=pde(var);
pb.eq='-Laplace(var)+Dyz(var)=(12*%pi^2)*f+4*%pi^2*fscc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.055 then pause, end
//------- Dzy
pb=pde(var);
pb.eq='-Laplace(var)+Dzy(var)=(12*%pi^2)*f+4*%pi^2*fscc';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.055 then pause, end
//
k=p1(test,'1+x');
//
pb=pde(var);
pb.eq='-Laplace(var)+kId(k,var)=(12*%pi^2)*f+k*f';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.045 then pause, end
//
pb=pde(var);
pb.eq='-kLaplace(k,var)=k*(12*%pi^2)*f-2*%pi*fcss';
assemble(pb);
lsolve(pb);
if max(abs(var-f)) > 0.046 then pause, end
