// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out]=z_grid3d_Node(g)
//tableau des abcisses des noeuds de g
[nx,ny,nz]=size(g);
out=matrix(g.z(:,ones(nx*ny,1))',-1,1);
endfunction
