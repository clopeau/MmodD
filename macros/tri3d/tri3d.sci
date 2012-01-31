function th=tri3d(%g,Bnd)
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
    id="";Coor=[];CoorId=[];Tri=[];TriId=[];
    if rhs==1
      id=%g;
    else
      ind=find(%g.BndId==Bnd)
      Tri=%g.Bnd(ind);
      tmp=unique(Tri);
      Coor=%g.Coor(tmp,:);
      CoorId=%g.CoorId(tmp,:);
      tmp2=spzeros(max(tmp),1);
      tmp2(tmp)=(1:length(tmp))'
      Tri=matrix(full(tmp2(Tri)),-1,3)
      TriId=ind*ones(size(Tri,1),1);
    end
    
    th=mlist(['tri3d';'#';'Id';'Coor';'CoorId';'Tri';'TriId';'BndId';'Bnd';..
	    'BndPerio';'Det';'Shape_p1_Grad'],..
	rand(),id,Coor,CoorId,Tri,TriId,[],list(),[],[],list())    
endfunction
