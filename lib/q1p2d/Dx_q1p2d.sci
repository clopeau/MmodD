function Mat=Dx_q1p2d(u)
   // matrice de masse sur tout le domaine
   // implantation sur un maillage de type grid3d !!

   // var locales
   G=evstr(u.geo);
   Base= [1 1 2 2;
          1 2 1 2]
   Delta=[1/6 1/12;
          1/12 1/6]
   [nx,ny]=size(G);
   ntot=nx*ny;
   
   hx=G.x(2:$)-G.x(1:$-1);
   hy=G.y(2:$)-G.y(1:$-1);
   hy=hy.*.ones(hx);
      
   // initialisation des matrices
   Mat=spzeros(ntot,ntot);  
   for ii=1:4
     i=Base(1,ii); j=Base(2,ii);
     //diagonale
     tmp=G(Base(:,ii),'c2n');
     for jj=1:4
       ip=Base(1,jj); jp=Base(2,jj); 
       //extra diag
       rrr=(-1)^(i+1)*Delta(j,jp);
       Mat=Mat+sparse([tmp, G(Base(:,jj),'c2n')],rrr*hy,[ntot,ntot]);
     end
   end
endfunction
