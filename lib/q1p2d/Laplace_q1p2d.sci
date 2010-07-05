function M=Laplace_q1p2d(u)
    // var locales
    Base= [1 1 2 2;
	   1 2 1 2]
     Delta=[1/3 1/6;
	   1/6 1/3];
    MM=ones(2,2)/2 + diag(ones(1,2))/2;
    // info sur grille
    G=evstr(u.geo);
    [nx,ny]=size(G);
    ntot=size(G);
    hx=G.x(2:$)-G.x(1:$-1);
    hy=G.y(2:$)-G.y(1:$-1);
    V=hy.*.hx;
    Gra=[ones(hy).*.(1 ./hx),...
	 (1 ./hy).*.ones(hx)]
 
    // initialisation des matrices
    K=eye(2,2);
    Diag=zeros(ntot,1);
    Mat=spzeros(ntot,ntot);
    for ii=1:4
      i=Base(1,ii); j=Base(2,ii);
      //diagonale
      I=[(-1)^i;(-1)^j];
      M=(I*I').*MM;
      M=M*Delta
      M=sparse(M.*K);
      Add=zeros(V);
      for ind=spget(M)'
	Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
      end
      tmp=G(Base(:,ii),'c2n');
      Diag(tmp)=Diag(tmp)-Add;
      for jj=ii+1:4
	ip=Base(1,jj); jp=Base(2,jj);
	//extra diag
	Ip=[(-1)^ip;(-1)^jp];
	M=(I*Ip').*MM;
	M(1,1)=M(1,1)*Delta(j,jp);
	M(2,2)=M(2,2)*Delta(i,ip);
	M=sparse(M.*K);
	Add=zeros(V);
	for ind=spget(M)'
	  Add=Add + M(ind(1),ind(2))*V.*prod(Gra(:,ind),'c');
	end
	Mat=Mat+sparse([tmp, G(Base(:,jj),'c2n')],-Add,[ntot,ntot]);
      end
    end
    M=Mat+Mat'+diag(sparse(Diag));
endfunction
