function []=tri2d_show_cell(th,ens)
// Affiche les numeros des triangles 
// (apres  mesh_plot)
// th  : mesh
// ens : ensemble de noeuds de triangle
  [p,n]=size(th);
  [lhs,rhs]=argn(0);
  if rhs==1 
    ens=1:n;
  end
  ens=matrix(ens,-1,1)
  barx=sum(matrix(th.Coor(th.Tri(ens,:),1),-1,3),'c')/3;
  bary=sum(matrix(th.Coor(th.Tri(ens,:),2),-1,3),'c')/3;

  for i=1:length(ens)
    xstring(barx(i),bary(i),string(ens(i)))
  end

endfunction
