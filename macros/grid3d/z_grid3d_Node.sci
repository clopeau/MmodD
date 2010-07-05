function [out]=z_grid3d_Node(g)
//tableau des abcisses des noeuds de g
[nx,ny,nz]=size(g);
out=matrix(g.z(:,ones(nx*ny,1))',-1,1);
endfunction
