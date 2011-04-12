// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  [ind,ind1]=%grid3d_e(varargin)
// fonction d''extraction de grille
// les frontieres sont
// N,S,E,W(=O),U,D

   [lhs,rhs]=argn(0);
 
   G=varargin($);
   if rhs==2
     opt='node'
   else
     opt=varargin($-1);
   end
   opt=convstr(opt,'l');
   In=varargin(1);
   
   // Extraction de frontieres 
   if type(In)==10
     // format
     opt=part(opt,1);
     In=convstr(In,'u');
     if In=='O'
       In='W';
     end
     // noeuds et cellules
     if opt=='n' | opt=='c'
       [nx,ny,nz]=size(G,opt);
       select In
       case 'S'
	 ind=find(ones(1:nz).*.[1 zeros(1:ny-1)].*.ones(1:nx));
         ind1=ind'+nx;
       case 'N'
	 ind=find(ones(1:nz).*.[zeros(1:ny-1) 1].*.ones(1:nx));
         ind1=ind'-nx; 
       case 'W'
	 ind=find(ones(1:nz).*.ones(1:ny).*.[1 zeros(1:nx-1)]);
         ind1=ind'+1;
       case 'E'
	 ind=find(ones(1:nz).*.ones(1:ny).*.[zeros(1:nx-1) 1]);
         ind1=ind'-1;
       case 'D'
	 ind=find([1 zeros(1:nz-1)].*.ones(1:ny).*.ones(1:nx));
         ind1=ind'+nx*ny;
       case 'U' 
	 ind=find([zeros(1:nz-1) 1].*.ones(1:ny).*.ones(1:nx));
         ind1=ind'-nx*ny;
       case 'I'
          ind = find([zeros(1:nx*ny),ones(1:nz-2).*.([zeros(1:nx),ones(1:ny-2).*.[0,ones(nx-2),0],zeros(1:nx)]),zeros(1:nx*ny)]);
       end
       
       
       // faces
     elseif opt=='f'
       [nfx,nfy,nfz]=size(G,opt);
       [nx,ny,nz]=size(G);
       select In
       case 'W'
	 ind=1:((ny-1)*(nz-1));
       case 'E'
	 ind=((nx-1)*(ny-1)*(nz-1)+1):nfx;
       case 'S'
	 ind=(nfx+1):(nfx+(nx-1)*(nz-1));
       case 'N'
	 ind=(nfx+(nx-1)*(ny-1)*(nz-1)+1):(nfx+nfy)
       case 'D'
	 ind=(nfx+nfy+1):(nfx+nfy+(nx-1)*(ny-1));
       case 'U'
	 ind=(nfx+nfy+(nx-1)*(ny-1)*(nz-1)+1):(nfx+nfy+nfz);
       end
     
       //arêtes
     elseif opt=='a'
       [nax,nay,naz]=size(G,opt);
       [nx,ny,nz]=size(G);
       select In
       case 'W'
	 ind=1:((ny-1)*nz+(nz-1)*ny);
       case 'E'
	 ind=(nx*(ny-1)*nz+(nz-1)*ny*nx+1):nax;
       case 'S'
	 ind=(nax+1):(nax+((nx-1)*nz+(nz-1)*nx));
       case 'N'
	 ind=(nax+((nx-1)*nz+(nz-1)*nx)*ny+1):(nax+nay)
       case 'D'
	 ind=(nax+nay+1):(nax+nay+((nx-1)*ny+(ny-1)*nx));
       case 'U'
	 ind=(nax+nay+((nx-1)*ny+(ny-1)*nx)*nz+1):(nax+nay+naz);
       end       
     end
     
     // Extaction par connexion
     // c2n : cellule 2 node 
     // pour chaque cellule le numero de noeud correspondant
   elseif opt=='c2n'
     // vecteur des num de noeuds par cellules
     // In doit etre dans [1 2]^2
     // [1 1 1] bas gauche
     // [1 2 1] bas droite
     // ....;
     [nx,ny,nz]=size(G);
     a=[nx 1];
     b=[nx*(ny-1) 0];
     c=[nx*ny*(nz-1) 0];
     ind=~zeros(nx*ny*nz,1)';
     ind(a(In(1)):nx:$)=%f;
     tmp=(b(In(2))+(1:nx))'*ones(1,nz)+ones(1,nx)'*(0:nx*ny:(nx*ny*nz-1));  
     ind(tmp(1:$))=%f;
     ind(c(In(3))+(1:nx*ny))=%f;
     ind=find(ind);
     
     // Extaction par connexion
     // c2f : cellule 2 face 
     // pour chaque cellule le numero de face correspondant
   elseif opt=='c2f'
     // vecteur des num d'arêtes par cellules
     // In doit etre dans [1 2 3]^2
     // [1 3 3] face W
     // [2 3 3] face E
     // 
     // 
     [nfx,nfy,nfz]=size(G,'f');
     [nx,ny,nz]=size(G);
     [i,j,k]=(In(1),In(2),In(3))
     
     if In(1)<3
       ind=zeros((nx-1),(ny-1)*(nz-1));
       ind(:,:)=(ny-1)*(nz-1);
       ind(1,:)=(1+(i-1)*(ny-1)*(nz-1)):i*(ny-1)*(nz-1);
       ind=matrix(cumsum(ind,"r"),-1,1);
     elseif In(2)<3
       tmp=zeros(ny-1,nz-1);
       tmp(:,:)=(nx-1)*(nz-1);
       tmp(1,:)=(1+(j-1)*(nx-1)*(nz-1)):(nx-1)...
	   :((nz-2)*(nx-1)+(j-1)*(nx-1)*(nz-1)+1);
       tmp=matrix(cumsum(tmp,"r"),1,-1);
       ind=ones(nx-1,(ny-1)*(nz-1));
       ind(1,:)=tmp;
       ind=matrix(cumsum(ind,"r"),-1,1);
       ind=ind+(nx*(ny-1)*(nz-1));
     elseif In(3)<3
       ind=(1+(k-1)*(nx-1)*(ny-1):(nz+k-2)*(nx-1)*(ny-1));
       ind=ind+(nx*(ny-1)*(nz-1))+(nx-1)*ny*(nz-1);
     end
  
   else
     error('Extraction de grid3d : option non reconnue')  
   end
   
   
   ind=matrix(ind,-1,1);
 endfunction
