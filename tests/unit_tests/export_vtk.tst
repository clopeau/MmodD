// Copyright (C) 2010-11 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// experimental tst
//<-- NO CHECK REF -->
//<-- TEST WITH GRAPHIC --> 

//=======  TRI2D ======
//---- tri2d and p1_2d
meshgeo=square2d(10,10);
u=p1(meshgeo,"x^2+y^2");
//paraview(u)

// tri2d and p0_2d
v=p0(u)
//paraview(v)

//----- tri2d 2-vector p1_2d
w=p1(meshgeo,["x","y"])
//paraview(w)

//----- tri2d 2-vector p0_2d
//select Cell center
w=p0(w)
//paraview(w)

// ---- tri2d 3-vector p1_2d
ww=p1(meshgeo,["x","y","x^2+y^2"])
//paraview(ww)

// ---- tri2d 3-vector p0_2d
// select Cell Center...
ww=p0(ww)
//paraview(w)

//=======  TRI3D ======
//tri3d and p1_2d
th=square2d_bamg(10,11)
u=p1(th,"x^2+y^2");
th=th+[0 0 0]
th.Coor(:,3)=u.Node
zz=p1(th,'z')
//paraview(zz);

//tri3d and p0_2d
zz=p0(zz)
//paraview(zz);

//tri3d 3-vector p1_2d
zz=p1(th,['x','y','z'])
//paraview(zz)

//tri3d 3-vector p0_2d
zz=p0(zz)
//paraview(zz);

//=======  TET3D ======

// tet3d and p1_3d
mh=tcube3d(10,9,11)
V=p1(mh,"x^2+y^2+z^2")
//paraview(V)

// tet3d and p0_3d
V=p0(V)
//paraview(v)

// tet3d 3-vector p1_3d
V=p1(mh,["x","y","z"])
//paraview(V)

// tet3d 3-vector p0_3d
// ******* Dont work
V=p0(V)
//paraview(v)


