// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) - 2009 - DIGITEO - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- JVM NOT MANDATORY -->

// Initialize the global variable containing the path
global %mmodd_path;
// Creates the variable "path" containing the path of the file to test 
path=%mmodd_path+"\demos\2d\Mesh_example/BAMG_octogone.msh";

// Execute the function on the previous file
th_Bamg = read_tri2d_BAMG(path);

// Verifies if the identity of the result is correct
if th_Bamg.Id <> path then pause, end
// Check if the boundary is correct 
if th_Bamg.BndId <> ['f1'] then pause, end

// Puts the number of triangles and points in variables a and b and check their values
[a,b]=size(th_Bamg);
if [a,b] <> [358 650] then pause, end

// Checks the number of border
border_number=length(th_Bamg.Bnd);
if border_number <> 1 then pause, end

// Verifies that the number of points in the border is OK
border=size(th_Bamg.Bnd(1));
if border <> [65 1] then pause, end

// Check again if the number of points is 358
// Remember : a = 358
[c,d]=size(th_Bamg.Coor);
if [c,d] <> [a 2] then pause, end

// Check again if the number of points is 650
// Remember : b = 650
[e,f]=size(th_Bamg.Tri);
if [e,f] <> [b 3] then pause, end

// Verifies that some randomly chosen points are OK
computed = th_Bamg.Coor(1);
expected = 1;
if abs(computed-expected)>%eps then pause,end

computed = th_Bamg.Coor(2);
expected = 0.707106781187;
if abs(computed-expected)>%eps then pause,end

computed = th_Bamg.Coor(100);
expected = 0.853553399959;
if abs(computed-expected)>%eps then pause,end

computed = th_Bamg.Coor(200);
expected = -0.801038097498;
if abs(computed-expected)>%eps then pause,end

computed = th_Bamg.Coor(358);
expected = -0.0956166302744;
if abs(computed-expected)>%eps then pause,end