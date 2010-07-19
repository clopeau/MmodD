function th=tri2d(nom)
// Type declaration
//
// Calling Sequence
// tri2d()
// tri2d(name)
//
// Parameters
// name : the tri2d's identity
//
// Description
// tri2d create a empty list that contains :
//    id : identity ('' if no parameter given) 
//    Coor : mesh point's coordinates matrix
//    Tri  : triangles matrix (the n points in the Tri matrix refers to the n-th row of the Coor matrix)
//    BndId : vector of the border 's name
//    Bnd : liste of the border points 
//
// Examples
// th=square2d(5,5)             // a square2d is a tri2d
// th.Id='my_square'
// th.Coor
// th.Tri
// th.BndId
// th.Bnd(2)
// th.E
// See also
// square2d
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['tri2d';'#';'Id';'Coor';'Tri';'Dom';'BndId';'Bnd';'BndPerio'],...
	rand(),nom,[],[],[],[],list(),[])
    
endfunction
