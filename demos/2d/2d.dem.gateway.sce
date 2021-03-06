// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

demopath = get_absolute_file_path("2d.dem.gateway.sce");
subdemolist = ["Getting started","getting_started.sce";..
               "Square hole","SquareHole2d.sce";..
               "Electric Potential","Potelec2d.sce";..
               "Animal Coat Patterns","ReactDiff_Patterns/react.dem.gateway.sce";..
               "Format mesh reading","mesh_read.sce";..
               "Mesh adaptation BAMG","adaptmesh_bamg.sce"];

subdemolist(:,2) = demopath + subdemolist(:,2);
clear demopath;
