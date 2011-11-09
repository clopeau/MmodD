// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=tet3d(nom)
// declaration de type
//-----------------------------------------------------------
// type mesh
//----------
//    id : identite
//    Coor : tableau des coordonnees des points du maillage colones en lignes
//    Tet  : tableau des indices de tetraedres (sens positif) 
//    BndId : table des noms frontières
//    BndNode : liste des indices des points frontiere
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['tet3d';'#';'Id';'Coor';'CoorId';'Tet';'TetId';'Tri';...
	    'TriId';'Tet2Tri';'BndId';'Bnd';'BndiTri';'Tmp';'Det';'size';'Shape_p1_Grad'],...
	rand(),nom,[],[],[],[],[],[],[],[],list(),list(),list(),[],[],list())
    
endfunction
