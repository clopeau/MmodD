function [y]=y_grid3d_Node(g)
//tableau des abcisses des noeuds de g
   [nx,ny,nz]=size(g);
   y=matrix(g.y(:,ones(nx,1))',-1,1)
   y=matrix(y(:,ones(nz,1)),-1,1)

endfunction
