function th=dcomp3d(nom)
// declaration de type
// decomposition polyhedres
    [lhs,rhs]=argn(0);
    if rhs==0
      nom="";
    end
    
    th=mlist(['dcomp3d';'#';'Id';'Coor';'Face';'Cell';'Type';'Mat'],...
	rand(),nom,[],list(),list(),[],[])
    
endfunction
