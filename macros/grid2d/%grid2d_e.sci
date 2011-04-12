// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  [ind,ind1]=%grid2d_e(varargin)
// fonction d''extraction de grille
// les frontieres sont
// N,S,E,W(=O)
// ind  : ensembles d'indices concernés
// ind1 : ensembles d'indices adjacents aux premiers

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
	    [nx,ny]=size(G,opt);
	    select In
	    case 'S'
	      ind=find([1 zeros(1:ny-1)].*.ones(1:nx));
	      ind1=ind'+nx;
	    case 'N'
	      ind=find([zeros(1:ny-1) 1].*.ones(1:nx));
	      ind1=ind'-nx;
	    case 'W'
	      ind=find(ones(1:ny).*.[1 zeros(1:nx-1)]);
	      ind1=ind'+1;
	    case 'E'
	      ind=find(ones(1:ny).*.[zeros(1:nx-1) 1]);
	      ind1=ind'-1; 
	    case 'I'
	      s = ones(1,nx);
	      s(1) = 0;
	      s(nx) = 0;
	      ind = find([zeros(1:nx),ones(1:ny-2).*.s,zeros(1:nx)]);
	    end
	    
     // arêtes
           elseif opt=='a'
	     [nfx,nfy]=size(G,opt);
	     [nx,ny]=size(G);
	     select In
	     case 'S'
	       ind=(nfx+1):(nfx+nx-1);
	     case 'N'
	       ind=(nfx+nfy-nx+1):(nfx+nfy);
	     case 'W'
	       ind=1:(ny-1);
	     case 'E'
	       ind=((ny-1)*(nx-1)+1):nfx;
	     end
     //faces
	   else
	     [nfx,nfy,nfz]=size(G,opt);
	     [nx,ny]=size(G);
	     ind=1:((nx-1)*(ny-1));
	   end
	   
   // Extaction par connexion
   // c2n : cellule 2 node 
   // pour chaque cellule le numero de noeud correspondant
   // syntaxe :
   //      G([1 1],'c2n')
   
   elseif opt=='c2n'
     // vecteur des num de noeuds par cellules
     // In doit etre dans [1 2]^2
     // [1 1] bas gauche
     // [1 2] bas droite
     // [2 1] haut gauche
     // [2 2] haut droit
     [nx,ny]=size(G);
     ax=[nx 1];
     ay=[ny 1];
     ind=~zeros(nx,ny);
     ind(ax(In(1)),:)=%f
     ind(:,ay(In(2)))=%f
     
     ind=find(matrix(ind,-1,1));
     
   // Extaction par connexion
   // c2f : cellule 2 face 
   // pour chaque cellule le numero de face correspondant
   elseif opt=='c2a'
     // vecteur des num des arêtes par faces
     // In doit etre dans [1 2 3]^2
     // [1 3] face W
     // [2 3] face E
     // [3 1] face S
     // [3 2] face N
     [nax,nay]=size(G,'a');
     [nx,ny]=size(G);
     ax=[0 ny-1];
     ay=[0 nx-1];
     if In(1)<3
       ind=(ax(In(1))+1):(nax-ax(modulo(In(1),2)+1));
     elseif In(2)<3
       ind=(nax+ay(In(2))+1):(nax+nay-ay(modulo(In(2),2)+1));
     end
   elseif opt=='c2f'
     nf=size(G,'f');
     ind=1:nf;
   else
     error('Extraction de grid2d : option non reconnue')
   end
   ind=matrix(ind,-1,1);
 endfunction
   
       
       
       
   
