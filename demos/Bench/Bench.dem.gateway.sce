// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

demopath = get_absolute_file_path("Bench.dem.gateway.sce");
dim=2;
ext=string(dim)+'d';
vtype=['p1_']+ext
grille=['square2d'];


subdemolist = [ ..
		"2d" , "Bench2d.dem.gateway.sce";
		"3d" , "Bench3d.dem.gateway.sce";
	      ]
    
subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
