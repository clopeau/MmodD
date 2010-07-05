function Mat=Dy_RT(u)
   // matrice de masse sur tout le domaine
   // implantation sur un maillage de type grid3d !!

     // var locales
     G=evstr(u.geo);
     
     Base= [1 2 3 3 3 3;
            3 3 1 2 3 3;
            3 3 3 3 1 2];
	
     Delta=[0 0 1/6 -1/6 0 0;
	    0 0 1/6 -1/6 0 0;
	    -1/6 -1/6 -1/2 1/6 -1/6 -1/6;
	    1/6 1/6 -1/6 1/2 1/6 1/6;
	    0 0 1/6 -1/6 0 0;
	    0 0 1/6 -1/6 0 0];
     
     ntot=size(G,"F");
     
     hx=G.x(2:$)-G.x(1:$-1);
     hy=G.y(2:$)-G.y(1:$-1);
     hz=G.z(2:$)-G.z(1:$-1);     
     //Calcul du volume
     Vol=hz.*.ones(hy).*.hx;
     Mat=spzeros(ntot,ntot); 
     for ii=1:6
       //diagonale
       tmp=G(Base(:,ii),'c2f');     
       for jj=1:6
	 rrr=Delta(ii,jj);    
	 Mat=Mat+sparse([tmp, G(Base(:,jj),'c2f')],rrr*Vol,[ntot,ntot]);
       end
     end
endfunction

