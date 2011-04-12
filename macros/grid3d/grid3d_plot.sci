// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function grid3d_plot(G,col)
  // fonction de trace de grille
  [lhs,rhs]=argn(0);
  if rhs==1
    col=3;
  end

  [nx,ny,nz]=size(G)
     x=zeros(2,ny*nz+nx*ny+nx*nz);
     y=zeros(2,ny*nz+nx*ny+nx*nz);
     z=zeros(2,ny*nz+nx*ny+nx*nz);
     X=G.x';
     Y=G.y';
     Z=G.z'
     // W to E
     x(1,1:ny*nz)=X(1);
     x(2,1:ny*nz)=X($);
     y(1,1:ny*nz)=matrix(Y'*ones(1,nz),1,-1);
     y(2,1:ny*nz)=y(1,1:ny*nz);
     z(1,1:ny*nz)=matrix(ones(ny,1)*Z,1,-1);
     z(2,1:ny*nz)=z(1,1:ny*nz);
     //  N to S
     ib=ny*nz+1; ih=ny*nz+nx*nz;
     x(1,ib:ih)=matrix(X'*ones(1,nz),1,-1);
     x(2,ib:ih)=x(1,ib:ih);
     y(1,ib:ih)=Y(1);
     y(2,ib:ih)=Y($);
     z(1,ib:ih)=matrix(ones(nx,1)*Z,1,-1);
     z(2,ib:ih)=z(1,ib:ih);
     //  N to S
     ib=ih+1;
     x(1,ib:$)=matrix(X'*ones(1,ny),1,-1);
     x(2,ib:$)=x(1,ib:$);
     y(1,ib:$)=matrix(ones(nx,1)*Y,1,-1);
     y(2,ib:$)=y(1,ib:$);
     z(1,ib:$)=Z(1);
     z(2,ib:$)=Z($);
  
     //affichage
     param3d1(x,y,list(z,col*ones(1,size(z,'c'))));

endfunction
   
   
