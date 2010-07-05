function M=div_grad_q1p3d(p,K)
    [lhs,rhs]=argn(0);
    
    // initialisation des matrices
    if rhs==1
      K=eye(3,3)
    end
    
    // var locales
    Base= [1 1 1 1 2 2 2 2;
	   1 1 2 2 1 1 2 2;
	   1 2 1 2 1 2 1 2];
    
    Delta=[1/3 1/6;
	   1/6 1/3];
    
    MM=ones(3,3)/4 + 3*diag(ones(1,3))/4;
    // info sur grille
    G=evstr(p.geo);
    
    ntot=size(G);
    
    hx=G.x(2:$)-G.x(1:$-1);
    hy=G.y(2:$)-G.y(1:$-1);
    hz=G.z(2:$)-G.z(1:$-1);
    
    V=hz.*.hy.*.hx;
    
    Gra=[ones(hz).*.ones(hy).*.(1 ./hx),...
	    ones(hz).*.(1 ./hy).*.ones(hx),...
	    1 ./hz.*.ones(hy).*.ones(hx)];

    Diag=zeros(ntot,1);
    Mat=spzeros(ntot,ntot);
    
    for ii=1:8
      i=Base(1,ii); j=Base(2,ii); k=Base(3,ii);
      //diagonale
      I=[(-1)^i;(-1)^j;(-1)^k];
      M=(I*I').*MM;
      M(2:3,2:3)=M(2:3,2:3)/3;
      M([1,3],[1,3])=M([1,3],[1,3])/3;
      M(1:2,1:2)=M(1:2,1:2)/3;
      M=sparse(M.*K);
      Add=zeros(V);
      for ind=spget(M)'
	Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
      end
      tmp=G(Base(:,ii),'c2n');
      Diag(tmp)=Diag(tmp)+Add;
      for jj=ii+1:8
	ip=Base(1,jj); jp=Base(2,jj); kp=Base(3,jj);
	//extra diag
	Ip=[(-1)^ip;(-1)^jp;(-1)^kp];
	M=(I*Ip').*MM;
	M(2:3,2:3)=M(2:3,2:3)*Delta(i,ip);
	M([1,3],[1,3])=M([1,3],[1,3])*Delta(j,jp);
	M(1:2,1:2)=M(1:2,1:2)*Delta(k,kp);
	M=sparse(M.*K);
	Add=zeros(V);
	for ind=spget(M)'
	  Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
	end
	Mat=Mat+sparse([tmp, G(Base(:,jj),'c2n')],Add,[ntot,ntot]);
      end
    end
    M=Mat+Mat'+diag(sparse(Diag));
endfunction
