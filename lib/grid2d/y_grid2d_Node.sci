function y=y_grid2d_Node(g)
//tableau des ordonn�es des noeuds de g
  [nx,ny]=size(g);
  y=matrix(g.y(:,ones(nx,1))',-1,1);
endfunction
