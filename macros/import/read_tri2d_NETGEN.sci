// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=read_tri2d_NETGEN(nombase)
    // read output file from NETGEN 4.3
    // file .vol exetension
    // 2d third composante of point must be 0

    u=file('open',nombase,'old');
    
    //---------- Lecture of dimension space ------------
    ligne=""
    while grep(ligne,"dimension")==[]
      ligne=read(u,1,1,'(a)');
    end
    n=read(u,1,1);
    nt=n+1;
    if n==3
      error('Wrong dimension of input mesh, use read_tet3d_NETGEN function')
    else
      th=tri2d(nombase);
    end
   
    //---------- Faces ------------
    ligne=""
    while grep(ligne,"surface")==[]
      ligne=read(u,1,1,'(a)');
    end
    nf=read(u,1,1);
    tmp=read(u,nf,8);
    th.TriId=tmp(:,2);
    th.Tri=tmp(:,6:8);
     
    //---------- edges ------------
    ligne=""
    while grep(ligne,"edge")==[]
      ligne = read(u,1,1,'(a)')
    end
    nv=read(u,1,1);
    tmp=read(u,nv,12);
    nbd=unique(tmp(:,1));
    cpt=0;
    for i=nbd'
      cpt=cpt+1;
      th.BndId=[th.BndId "f"+string(i)];
      ed=tmp(tmp(:,1)==i,3:4);
      a1=unique(ed(:,1));
      a2=unique(ed(:,2));
      if and(a1==a2)
	bd=zeros(a1);
	bd(1)=ed(1,1);
	bd(2)=ed(1,2);
	for j=3:length(a1);
	  k=find(ed(:,1)==bd(j-1))
	  bd(j)=ed(k,2);
	end
	th.Bnd(cpt)=bd;
      else
	error("2d read NETGEN File :Not implemented contact me or write it!")
      end
    end
    
    
    
    //---------- Points --------------
    while grep(ligne,"points")==[]
      ligne=read(u,1,1,'(a)');
    end
    np=read(u,1,1);
    th.Coor=read(u,np,3);
    th.Coor(:,3)=[];
    
    file('close',u);
    
    
endfunction
  
