function th=hex3d(nom)
// declaration de type
//-----------------------------------------------------------
// type mesh
//----------
//    id : identite
//    Coor : tableau des coordonnees des points du maillage colones en lignes
//    Hex  : tableau des indices de Hexaedres  
//    BndId : table des noms frontières
//    BndNode : liste des indices des points frontiere
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['hex3d';'#';'Id';'Coor';'Hex';'Dom';'BndId';'Bnd';'BndCnx'],...
	rand(),nom,[],[],[],[],list(),[])
    
endfunction
