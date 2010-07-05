function Mat=Id_RT(u,opt)
   [lhs,rhs]=argn(0);
   
   if rhs==1 then
   // matrice de masse sur tout le domaine
   // implantation sur un maillage de type grid3d !!

     // var locales
     G=evstr(u.geo);
     Base= [1 2 3 3 3 3;
	    3 3 1 2 3 3;
	    3 3 3 3 1 2]; 

  //Pour Le calcul des coefficients de la matrice de masse 
  // voir le fichier correspondant Texmax   
     Masse=[13/90 -1/45 1/90 1/90 1/90 1/90;
            -1/45 13/90 1/90 1/90 1/90 1/90;
	    1/90 1/90 13/90 -1/45 1/90 1/90;
	    1/90 1/90 -1/45 13/90 1/90 1/90;
	    1/90 1/90 1/90 1/90 13/90 -1/45;
	    1/90 1/90 1/90 1/90 -1/45 13/90];
     
     // info sur grille
     ntot=size(G,"Face");
     
     hx=G.x(2:$)-G.x(1:$-1);
     hy=G.y(2:$)-G.y(1:$-1);
     hz=G.z(2:$)-G.z(1:$-1);
     //Calcul du volume
     Vol=hz.*.hy.*.hx;
     // initialisation des matrices
     Diag=zeros(ntot,1);
     Mat=spzeros(ntot,ntot);  
     for ii=1:6
       //diagonale
       tmp=G(Base(:,ii),'c2f');
       Diag(tmp)=Diag(tmp)+Vol*Masse(ii,ii);
       for jj=ii+1:6
	 //extra diag
	 rrr=Masse(ii,jj);
	 Mat=Mat+sparse([tmp, G(Base(:,jj),'c2f')],rrr*Vol,[ntot,ntot]);
       end
     end
     Mat=Mat+Mat'+spdiag(Diag);
   
   else
     Base=[1 2 3 3 3 3;
	   3 3 1 2 3 3;
	   3 3 3 3 1 2];
     opt=convstr(opt,'u');
     if opt=='O'
       opt='W';
     end
	
     select opt
     case 'S'
       X=evstr(u.geo+'.x');
       Y=evstr(u.geo+'.z');
       Beta=[-1/180 -1/180 91/90 1/90 -1/180 -1/180];
     case 'N'
       X=evstr(u.geo+'.x');
       Y=evstr(u.geo+'.z');
       Beta=[-1/180 -1/180 1/90 91/90 -1/180 -1/180]
     case 'W'
       X=evstr(u.geo+'.y');
       Y=evstr(u.geo+'.z');
       Beta=[91/90 1/90 -1/180 -1/180 -1/180 -1/180];
     case 'E'
       X=evstr(u.geo+'.y');
       Y=evstr(u.geo+'.z');
       Beta=[1/90 91/90 -1/180 -1/180 -1/180 -1/180];
     case 'D'
       X=evstr(u.geo+'.x');
       Y=evstr(u.geo+'.y');
       Beta=[-1/180 -1/180 -1/180 -1/180 91/90 1/90];
     case 'U'
       X=evstr(u.geo+'.x');
       Y=evstr(u.geo+'.y');
       Beta=[-1/180 -1/180 -1/180 -1/180 1/90 91/90];
     end
    
     G=evstr(u.geo);
     nf=size(G,'F');
     //evstr('size('+u.geo+',''F'')');
     hx=X(2:$)-X(1:$-1);
     hy=Y(2:$)-Y(1:$-1);
     // Calcul du volume
     Vol=hy.*.hx;
     // initialisation des matrices
     Mat=spzeros(nf,nf);
     //diagonale
     tmp=G(opt,"F");
     //for jj=1:6
       //extra diag
     //  rrr=Beta(jj);
     //  Ind=G(opt,"c");
     //  I=G(Base(:,jj),"c2f");
     //  tmp2=I(Ind);
     Mat=sparse(tmp(:,[1 1]),ones(tmp),[nf,nf]);
     //end
   end
endfunction
