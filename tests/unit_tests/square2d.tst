// Copyright (C) 2011 - Quentin Pallotta
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//<-- NO CHECK REF -->
test=square2d(3,3);
if test.Id <> 'square2d' then pause, end
if test.BndId <> ['W' 'E' 'N' 'S'] then pause, end
if test.Bnd(1) <> [1;4;7] then pause, end
