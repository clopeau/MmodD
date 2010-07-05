function Mat=Id_q1p2d(u,opt)
   [lhs,rhs]=argn(0);
   
   if rhs==1 then
   // matrice de masse sur tout le domaine
   // implantation sur un maillage de type grid3d !!

     // var locales
     G=evstr(u.geo);
     Base= [1 1 2 2;
	    1 2 1 2]

     Delta=[1/3 1/6;1/6 1/3];
     
     [nx,ny]=size(G);
     ntot=nx*ny;
     
     hx=G.x(2:$)-G.x(1:$-1);
     hy=G.y(2:$)-G.y(1:$-1);
     //Calcul du volume
     Vol=hy.*.hx;
     // initialisation des matrices
     Diag=zeros(ntot,1);
     Mat=spzeros(ntot,ntot);  
     for ii=1:4
       i=Base(1,ii); j=Base(2,ii);
       //diagonale
       tmp=G(Base(:,ii),'c2n');
       Diag(tmp)=Diag(tmp)+Vol/9;
       for jj=ii+1:4
	 ip=Base(1,jj); jp=Base(2,jj); 
	 //extra diag
	 rrr=Delta(i,ip)*Delta(j,jp);
	 Mat=Mat+sparse([tmp, G(Base(:,jj),'c2n')],rrr*Vol,[ntot,ntot]);
       end
     end
     Mat=Mat+Mat'+spdiag(Diag);
   
   else
     // var locales
     Base= [1 2]
	
     // poids d-integration
     Delta=[1/3 1/6; 1/6 1/3];
     //Delta=[1/2 0; 0 1/2];

     opt=convstr(opt,'u');
     if opt=='O'
       opt='W';
     end
	
     select opt
     case 'S'
       X=evstr(u.geo+'.x');
     case 'N'
       X=evstr(u.geo+'.x');
     case 'W'
       X=evstr(u.geo+'.y');
     case 'E'
       X=evstr(u.geo+'.y');
     end
     
     ntot=evstr('size('+u.geo+')');
     Index=evstr(u.geo+'('''+opt+''')');     
     
     hx=X(2:$)-X(1:$-1);
     
     Vol=hx;
     // initialisation des matrices
     Diag=zeros(ntot,1);
     Mat=spzeros(ntot,ntot);
     for ii=1:2
       //diagonale
       tmp=Index((1+ii-1):(length(X)+ii-2));
       Diag(tmp)=Diag(tmp)+Vol/3;
       for jj=ii+1:2
	 rrr=Delta(ii,jj);
	 Mat=Mat+sparse([tmp,Index((1+jj-1):(length(X)+jj-2))],rrr*Vol,[ntot,ntot]);
       end
     end
     Mat=Mat+Mat'+diag(sparse(Diag));
   end

 
endfunction
