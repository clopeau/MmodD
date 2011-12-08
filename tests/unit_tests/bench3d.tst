// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

meshgeo=tcube3d(20,20,20);
u=p1(meshgeo);
pb=pde(u);
pb.eq='-Laplace(u)=12*%pi^2*cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.S='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.N='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.W='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.E='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.U='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.D='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
u_ex=p1(meshgeo,'cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)');
//pb=assemble_pde_p1_3d(pb,1:2);
assemble(pb);
lsolve(pb);
if max(abs(u-u_ex)) > 0.0495 then pause, end
 
