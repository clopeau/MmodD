// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

tmp=lines();
lines(0);

th=circle2d(1,100)

for i=1:20
    
eps=p1(th,"0.01")
u=p1(th,"(10*x^3+y^3)+atan(eps,sin(5*y)-2*x)")
vartool(u,"3d")
th=adaptmesh_bamg(th,u,hmax=0.03)

meshtool(th)
end

lines(tmp)
