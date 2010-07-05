function th=tri2d(nom)
// declaration de type
//-----------------------------------------------------------
// type mesh
//----------
//    id : identite
//    Coor : tableau des coordonnees des points du maillage colones en lignes
//    Tri  : tableau des indices de triangles (sens positif) 
//    BndId : table des noms frontières
//    BndNode : liste des indices des points frontiere
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['tri2d';'#';'Id';'Coor';'Tri';'Dom';'BndId';'Bnd';'BndPerio'],...
	rand(),nom,[],[],[],[],list(),[])
    
endfunction
