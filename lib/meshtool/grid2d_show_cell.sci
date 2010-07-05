function []=grid2d_show_cell(th,ens)
// Affiche les numeros des triangles 
// (apres  mesh_plot)
// th  : mesh
// ens : ensemble de noeuds de triangle
  [nx,ny]=size(th);
  n=size(th,'c');
  [lhs,rhs]=argn(0);
  if rhs==1 
    ens=1:n;
  end
  ens=matrix(ens,-1,1)
  barx=(th.x(1:$-1)+th.x(2:$))/2;
  barx=barx(:,ones(1:ny-1));
  bary=(th.y(1:$-1)+th.y(2:$))/2;
  bary=bary(:,ones(1:nx-1),:)';

  for i=1:length(ens)
    xstring(barx(i),bary(i),string(ens(i)))
  end

endfunction
