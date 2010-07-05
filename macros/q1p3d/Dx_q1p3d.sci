function Mat=Dx_q1p3d(u)
   // matrice de masse sur tout le domaine
   // implantation sur un maillage de type grid3d !!

     // var locales
     G=evstr(u.geo);
     Base= [1 1 1 1 2 2 2 2;
            1 1 2 2 1 1 2 2;
            1 2 1 2 1 2 1 2];
	
     Delta=[1/3 1/6;1/6 1/3];
     
     ntot=size(G);
     
     hx=G.x(2:$)-G.x(1:$-1);
     hy=G.y(2:$)-G.y(1:$-1);
     hz=G.z(2:$)-G.z(1:$-1);     
     //Calcul du volume
     Vol=hz.*.hy.*.ones(hx);
     Mat=spzeros(ntot,ntot); 
     for ii=1:8
       i=Base(1,ii); j=Base(2,ii); k=Base(3,ii);
       //diagonale
       tmp=G(Base(:,ii),'c2n');     
       for jj=1:8
	 ip=Base(1,jj); jp=Base(2,jj); kp=Base(3,jj);
	 rrr=(-1)^(i+1)*Delta(j,jp)* Delta(k,kp)/2; 
	 Mat=Mat+sparse([tmp, G(Base(:,jj),'c2n')],rrr*Vol,[ntot,ntot]);
       end
     end
endfunction
