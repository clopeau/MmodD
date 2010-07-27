// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function []=tri2d_show_face(th,ens)
 [lhs,rhs]=argn(0);
 index=[1 2; 2 3; 3 1]';
 [np,nq]=size(th);
 
 spEdge=sparse([1,1],%F,[np,np]);
 for i=index
   spEdge=spEdge | sparse(th.Tri(:,i),~zeros(1:nq),[np,np]);
 end
 spEdge=triu(spEdge)|tril(spEdge)'

 Edge=spget(spEdge)


 if rhs==1 
   ens=1:size(Edge,'r');
 end

 barx=sum(matrix(th.Coor(Edge(ens,:),1),-1,2),'c')/2;
 bary=sum(matrix(th.Coor(Edge(ens,:),2),-1,2),'c')/2;
 
  xstring(barx(ens),bary(ens),string(ens)); 
// for i=1:length(ens)
  // xstring(barx(ens(i)),bary(ens(i)),string(ens(i)));
// end

endfunction
