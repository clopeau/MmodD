// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt



demopath = get_absolute_file_path("MmodD.dem.gateway.sce");

subdemolist = ["2d problem","2d/2d.dem.gateway.sce";..
               "3d problem","inprogress.sce";..
	       "Benchmark" , "inprogress.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
