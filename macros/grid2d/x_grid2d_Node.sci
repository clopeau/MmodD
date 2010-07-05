function x=x_grid2d_Node(g)
//tableau des abcisses des noeuds de g
  [nx,ny]=size(g);
  x=matrix(g.x(:,ones(ny,1)),-1,1);
endfunction
