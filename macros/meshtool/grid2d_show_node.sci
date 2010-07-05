function []=grid2d_show_node(g,ens)
// affiche le numero des nodes sur le maillage 
// (apres  mesh_plot) il est possible de désigner un sous ensemble
// g  : grid2d
// ens : sous ensemble de noeud

  [lhs,rhs]=argn(0);
  if rhs==1 
    ens=1:size(g);
  end
  ens=matrix(ens,-1,1)
  X=matrix(g.x(:,ones(g.y)),-1,1);
  Y=matrix(g.y(:,ones(g.x))',-1,1);
  for i=1:length(ens)
    xstring(X(ens(i)),Y(ens(i)),string(ens(i)));
  end
endfunction
