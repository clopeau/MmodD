function Mat=StiffNC_vitesse(K,G,force)
 // Calcul de la matrice modifie relative a la vitesse Darcy 
 // G : type grid

  [lhs,rhs]=argn(0);
  if rhs==1
    G=K;
    K=eye(3,3)
  end

  // var locales
  Base= [1 2 3 3 3 3;
	 3 3 1 2 3 3;
	 3 3 3 3 1 2];
  Beta=[7/3 1/3 -2/3;
	1/3 7/3 -2/3;
       -2/3 -2/3 1/3];
  // info sur grille
  ntot=size(G,"Face");
  hx=G.x(2:$)-G.x(1:$-1);
  hy=G.y(2:$)-G.y(1:$-1);
  hz=G.z(2:$)-G.z(1:$-1);
  // Calcul du volume 
  V=produit(hx,hy,hz);
  Gra=[produit(1 ./hx,ones(hy),ones(hz)),...
       produit(ones(hx),1 ./hy,ones(hz)),...
       produit(ones(hx),ones(hy),1 ./hz)];
    // initialisation des matrices
  Diag=zeros(ntot,1);
  Mat=spzeros(ntot,ntot);
  
  // Assemblage suivant : ligne base de sortie
  
  for ii=1:6
    i=Base(1,ii); j=Base(2,ii); k=Base(3,ii);
    tmp=getNodeNC(i,j,k,G);
    // Attention pas symetrique    
    for jj=1:6
      ip=Base(1,jj); jp=Base(2,jj); kp=Base(3,jj);
      //extra diag
      M=Beta(Base(:,ii),Base(:,jj)).*K/2; // 2 
      Add=zeros(V);
      for ind=spget(sparse(M))';
	Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
      end
      Mat=Mat+sparse([tmp, getNodeNC(ip,jp,kp,G)],(-1)^ii*Add,[ntot,ntot]);
    end
  end
  
  // 
  for Face=['W' 'E' 'S' 'N' 'U' 'D']
    ind=getBnd(Face,G,"Face");
    Mat(ind,:)=Mat(ind,:)*2;
  end
  
  Face=[produit(1 ./hy , 1 ./hz,ones(G.x));...
	produit(1 ./hx,1 ./hz,ones(G.y));...
	produit(1 ./hx,1 ./hy,ones(G.z))];
  ij=(1:ntot)';
  Mat=sparse( ij(:,[1,1]),Face,[ntot,ntot])*Mat;

 endfunction

function vcel=velocity_cel(G,vit)
// post-traitement de la vitesse aux cellules

  [nx,ny,nz]=size(G,"Node");
    
  ncel=size(G,"Cell");
  nface=size(G,"Face");
  
  vcel=zeros(ncel,3)
  Diag=1/2;
  Diag=Diag(ones(2*ncel,1));
  
  alpha=nx*(ny-1)*(nz-1);
  beta=alpha+(nx-1)*ny*(nz-1);
  
  u=1:ncel;
  Ax=sparse([[u';u'],[getNodeNC(1,3,3,G);getNodeNC(2,3,3,G)]],Diag,[ncel,nx*(ny-1)*(nz-1)]);
  Ay=sparse([[u';u'],[getNodeNC(3,1,3,G);getNodeNC(3,2,3,G)]-alpha],Diag,[ncel,(nx-1)*ny*(nz-1)]);
  Az=sparse([[u';u'],[getNodeNC(3,3,1,G);getNodeNC(3,3,2,G)]-beta],Diag,[ncel,(nx-1)*(ny-1)*nz]);
  
  vcel(:,1)=Ax*vit(1:nx*(ny-1)*(nz-1),1);
  vcel(:,2)=Ay*vit(alpha+1:beta,1);
  vcel(:,3)=Az*vit(beta+1:$,1);
  
endfunction

function pcel=pressure_cel(G,p)
// post-traitement de la pression aux cellules

  [nx,ny,nz]=size(G,"Node");
    
  ncel=size(G,"Cell");
  nface=size(G,"Face");
  
  pcel=zeros(ncel,1)
  Diag=1/6;
  Diag=Diag(ones(2*ncel,1));
  
  alpha=nx*(ny-1)*(nz-1);
  beta=alpha+(nx-1)*ny*(nz-1);
  
  u=1:ncel;
  Ax=sparse([[u';u'],[getNodeNC(1,3,3,G);getNodeNC(2,3,3,G)]],Diag,[ncel,nx*(ny-1)*(nz-1)]);
  Ay=sparse([[u';u'],[getNodeNC(3,1,3,G);getNodeNC(3,2,3,G)]-alpha],Diag,[ncel,(nx-1)*ny*(nz-1)]);
  Az=sparse([[u';u'],[getNodeNC(3,3,1,G);getNodeNC(3,3,2,G)]-beta],Diag,[ncel,(nx-1)*(ny-1)*nz]);
  
  pcel(:,1)=Ax*p(1:nx*(ny-1)*(nz-1),1) + Ay*p(alpha+1:beta,1) + Az*p(beta+1:$,1);
 
endfunction




 
