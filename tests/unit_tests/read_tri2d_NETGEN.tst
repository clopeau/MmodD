// Copyright (C) 2011 - Quentin Pallotta
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//<-- NO CHECK REF -->


// Creates the variable "path" containing the path of the file to test 
mypath=mmodd_getpath()+"/demos/2d/Mesh_example/NETGEN_squarehole.vol";

// Execute the function on the previous file
th_NETGEN = read_tri2d_NETGEN(mypath);

// Verifies if the identity of the result is correct
if th_NETGEN.Id <> mypath then pause, end
// Check if the boundary is correct 
if th_NETGEN.BndId <> ['f1' 'f2'] then pause, end

// Puts the number of triangles and points in variables a and b and check their values
[a,b]=size(th_NETGEN);
if [a,b] <> [344 616] then pause, end

// Checks the number of border
border_number=length(th_NETGEN.Bnd);
if border_number <> 2 then pause, end

// Verifies that the number of points in the border is OK
border=size(th_NETGEN.Bnd(1));
if border <> [40 1] then pause, end

// Check again if the number of points is 358
// Remember : a = 344
[c,d]=size(th_NETGEN.Coor);
if [c,d] <> [a 2] then pause, end

// Check again if the number of points is 650
// Remember : b = 616
[e,f]=size(th_NETGEN.Tri);
if [e,f] <> [b 3] then pause, end

// Verifies that some randomly chosen points are OK
computed = th_NETGEN.Coor(1);
expected = 0;
if abs(computed-expected)>%eps then pause,end

computed = th_NETGEN.Coor(2);
expected = 0.1999999999999965;
if abs(computed-expected)>%eps then pause,end

computed = th_NETGEN.Coor(100);
expected = 0.8999999999999996;
if abs(computed-expected)>%eps then pause,end

computed = th_NETGEN.Coor(200);
expected = 0.9302289348387563;
if abs(computed-expected)>%eps then pause,end

computed = th_NETGEN.Coor(344);
expected = 0.5797047010066846;
if abs(computed-expected)>%eps then pause,end
