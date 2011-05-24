// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) - 2009 - DIGITEO - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- JVM NOT MANDATORY -->

test=square2d(3,3);
if test.Id <> 'square2d' then pause, end
if test.BndId <> ['W' 'E' 'N' 'S'] then pause, end
if test.Bnd(1) <> [1;4;7] then pause, end
