function M=div_grad_RT(u,K)
    [lhs,rhs]=argn(0);
   
    if rhs==1
      // initialisation des matrices
      K=[1 0 0;
	 0 1 0;
	 0 0 1];
    end
    
    // var locales
    Base= [1 2 3 3 3 3;
	   3 3 1 2 3 3;
	   3 3 3 3 1 2];
    
    Beta= [7/3 1/3 -2/3;
	   1/3 7/3 -2/3;
          -2/3 -2/3 1/3];
    
    // info sur grille
    G=evstr(u.geo);
    
    ntot=size(G,"Face");
    
    hx=G.x(2:$)-G.x(1:$-1);
    hy=G.y(2:$)-G.y(1:$-1);
    hz=G.z(2:$)-G.z(1:$-1);
    
    V=hz.*.hy.*.hx;
    
    Gra=[ones(hz).*.ones(hy).*.(1 ./hx),...
	    ones(hz).*.(1 ./hy).*.ones(hx),...
	    1 ./hz.*.ones(hy).*.ones(hx)];

    Diag=zeros(ntot,1);
    Mat=spzeros(ntot,ntot);
    
    for ii=1:6
      //diagonale
      M=Beta(Base(:,ii),Base(:,ii)).*K;
      Add=zeros(V);
      for ind=spget(sparse(M))'
	Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
      end
      tmp=G(Base(:,ii),'c2f');
      Diag(tmp)=Diag(tmp)+Add;
      for jj=ii+1:6
	//extra diag
	M=Beta(Base(:,ii),Base(:,jj)).*K;
	Add=zeros(V);
	for ind=spget(sparse(M))'
	  Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
	end
	Mat=Mat+sparse([tmp, G(Base(:,jj),'c2f')],Add,[ntot,ntot]);
      end
    end
    M=Mat+Mat'+diag(sparse(Diag));
endfunction
