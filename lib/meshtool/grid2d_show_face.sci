function []=grid2d_show_face(g,ens)
// affiche le numero des nodes sur le maillage 
// (apres  mesh_plot) il est possible de désigner un sous ensemble
// g  : grid2d
// ens : sous ensemble de noeud

  [nx,ny]=size(g);
  [lhs,rhs]=argn(0);
  if rhs==1 
    ens=1:((nx-1)*ny+nx*(ny-1));
  end
  
  ens=matrix(ens,-1,1);
  barx=(g.x(1:$-1)+g.x(2:$))/2;
  bary=(g.y(1:$-1)+g.y(2:$))/2;
  X=matrix(g.x(:,ones(bary))',-1,1);
  Y=matrix(g.y(:,ones(barx))',-1,1);
  barx=barx(:,ones(1:ny));
  bary=bary(:,ones(1:nx));
  for i=find(ens<=(nx*(ny-1)))
    xstring(X(ens(i)),bary(ens(i)),string(ens(i)));
  end
  for i=find(ens>(nx*(ny-1)))
    xstring(barx(ens(i)-nx*(ny-1)),Y(ens(i)-nx*(ny-1)),string(ens(i)));
  end
endfunction
