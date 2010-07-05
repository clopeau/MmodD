function th=quad3d(nom)
// declaration de type
//-----------------------------------------------------------
// type mesh
//----------
//    id : identite
//    Coor : tableau des coordonnees des points du maillage colones en lignes
//    Quad  : tableau des indices des quadrangles (sens positif) 
//    BndId : table des noms frontières
//    BndNode : liste des indices des points frontiere
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['quad3d';'#';'Id';'Coor';'Quad';'Dom';'BndId';'Bnd';'BndPerio'],...
	rand(),nom,[],[],[],[],list(),[])
    
endfunction
