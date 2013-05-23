// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=square2d_bamg(x,y,nx,ny);

  [lhs,rhs]=argn();
  if rhs==0
    // carre unite 4 nodes 2 triangles
    x=[0;1];nx=2;
    y=[0;1];ny=2;

  elseif rhs==2 
    if length(x)==1 & length(y)==1 // carre unite de nx,ny points par ligne
      nx=max(x,2);
      ny=max(y,2);
      x=linspace(0,1,nx)';
      y=linspace(0,1,ny)';
    elseif length(x)>1 & length(y)>1
      nx=length(x);x=matrix(x,-1,1);
      ny=length(y);y=matrix(y,-1,1);
    else
      error('Bad arguments in square2d function');
      return
    end
  elseif rhs==4&length(x)==2&length(y)==2&length(nx)==1&length(ny)==1
    x=linspace(x(1),x(2),nx)';
    y=linspace(y(1),y(2),ny)';
  else
    error('Bad arguments in square2d function');
    return
  end

  th=tri2d("square2d");
  th.Coor=[x   y(ones(nx,1)); 
           x(nx*ones(ny-1,1)) y(2:ny);
	   x(nx-1:-1:1) y(ny*ones(nx-1,1));
	   x(ones(ny-2,1)) y(ny-1:-1:2)]
  th.BndId=['W' 'E' 'N' 'S'];
  th.BndPerio=~ones(4,1);
  th.Bnd=list((1:nx)',..
              (nx:nx+ny-1)',..
	      (nx+ny-1:2*nx+ny-2)',..
	      [(2*nx+ny-2:2*nx+2*ny-4)';1])
  th=bamg(th);
  th.BndId=['W' 'E' 'N' 'S'];

endfunction
