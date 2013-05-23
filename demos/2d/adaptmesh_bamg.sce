// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

tmp=lines();
lines(0);

th=circle2d_bamg(1,100)
meshtool(th)
xtitle('initial mesh')

for i=1:5

    eps=p1(th,"0.01")
    u=p1(th,"(10*x^3+y^3)+atan(eps,sin(5*y)-2*x)")
    //v=p1(th,"(10*y^3+x^3)+atan(eps,sin(5*x)-2*y)")

    th=adaptmesh_bamg(th,u,AbsError=1,NoRescaling=1,NbJacobi=2,NbSmooth=5,hmax=2,hmin=0.000005,ratio=0,nbv=5000,v=4,err=0.05,errg=0.01)

    meshtool(th)
    xtitle('mesh at the '+string(i)+' iteration')
end

lines(tmp)
