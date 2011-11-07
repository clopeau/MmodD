// Copyright (C) 2010 - Clopeau T., Delanoue D., Ndeffo M. and Smatti S.
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=tri2d(nom)
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['tri2d';'#';'Id';'Coor';'CoorId';'Tri';'TriId';..
	    'BndId';'Bnd';'BndPerio';'Det';'Base_p1'],..
	rand(),nom,[],[],[],[],[],list(),[],[],list())
    
endfunction
