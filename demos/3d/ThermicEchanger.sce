// Copyright (C) 2011 - Sébastien Ternisien
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// Problem using the NetGen MeshTools

tmp=lines();
lines(0);
stacksize('max')
global %mmodd_path
write(%io(2),'')
write(%io(2),'')
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'       +  MmodD   Thermic Exchanger 3d     +');
write(%io(2),'       +++++++++++++++++++++++++++++++++++++');
write(%io(2),'')
write(%io(2),'')

th=read_tet3d_NETGEN(%mmodd_path+"/demos/3d/Mesh_example/ThermicExchanger.vol");
disp(th)
// Modification of boundaries
index=[3:5,7:8,11:34];
for i=index
  th.Bnd(6)=[th.Bnd(6) ;th.Bnd(i)];
end
th.Bnd(3)=th.Bnd(10);
th.Bnd(4)=th.Bnd(35);
th.Bnd(5)=th.Bnd(9);
  
for i=35:-1:7
  th.Bnd(i)=null();
end
th.BndId='f'+string(1:length(th.Bnd));
  
//  Mesh visualisation
meshtool(th)

// Constant definitions
T0=273+100; //Average temperature of a hot micro processor Température
Tinf=273+20; //Average outside temperature 
k0=237; //Thermcal conductivity of aluminium
h=50; //Coefficient of thermical convection. air, with forced convection: 10-500

// Variable definition
T=p1(th);

// Problem definition
pb=pde(T);
// Main equation
pb.eq='-k0*Laplace(T)=0';
// surface in contact with the hot piece at the temperature of T0
// Boundary condition on the surafce in contact with the hot piece at the temperature of T0 :
pb.f1="Id(T)=T0";

// By symetry, flux are nulls :
pb.f2="Dn(T)=0";
pb.f3="Dn(T)=0";
pb.f4="Dn(T)=0";
pb.f5="Dn(T)=0";

// convective flux
// Boundary condition on the wings and above the base with an heat exchange thanks to a convective flux :
pb.f6="Dn(T)-h*Id(T)=-h*Tinf";

// Assembling process');
txt=assemble(pb)
disp(txt)
// Linear resolution');
txt=lsolve(pb);
disp(txt);
// Result visualisation')
vartool(T)

lines(tmp(1));
