function []=tri2d_show_node(th,ens)
// affiche le numero des nodes sur le maillage 
// (apres  mesh_plot) il est possible de d�signer un sous ensemble
// th  : mesh
// ens : sous ensemble de noeud

  [lhs,rhs]=argn(0);
  if rhs==1 
    ens=1:size(th);
  end
  ens=matrix(ens,-1,1)
  xstring(th.Coor(ens,1),th.Coor(ens,2),string(ens));
 // for i=1:length(ens)
    //xstring(th.Coor(ens(i),1),th.Coor(ens(i),2),string(ens(i)));
  //end
endfunction
