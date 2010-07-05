function th=importNETGEN(nombase)
    // lecture des fichiers de sortie NETGEN 4.3
    // fichier nombase.vol
    //

    u=file('open',nombase+'.vol','unknown');
    
    
    //---------- Lecture de la dimension ------------
    ligne=""
    while grep(ligne,"dimension")==[]
      ligne=read(u,1,1,'(a)');
    end
    n=read(u,1,1);
    nt=n+1;
    if n==2
      th=tri2d(nombase);
    else
      th=tet3d(nombase);
    end
   
    //---------- Faces ------------
    ligne=""
    while grep(ligne,"surface")==[]
      ligne=read(u,1,1,'(a)');
    end
    nf=read(u,1,1);
    tmp=read(u,nf,8);
    ind=tmp(:,2);
    tmp=tmp(:,6:8);
    num=unique(ind);
    for i=1:length(num)
      th.BndId(i)='f'+string(num(i));
      th.Bnd(i)=tmp(ind==num(i),:);
    end
   th.BndId=th.BndId';
    //---------- Tetrahedres ------------
    ligne=""
    while grep(ligne,"volume")==[]
      ligne=read(u,1,1,'(a)')
    end
    nv=read(u,1,1);
    tmp=read(u,nv,6);
    th.TetId=tmp(:,1);
    th.Tet=tmp(:,3:6);
    
    //---------- Segments ------------
    while grep(ligne,"edge")==[]
      ligne=read(u,1,1,'(a)');
    end
    ns=read(u,1,1);

    
    //---------- Points --------------
    while grep(ligne,"points")==[]
      ligne=read(u,1,1,'(a)');
    end
    np=read(u,1,1);
    th.Coor=read(u,np,3);
    
    file('close',u);
    
    
endfunction
  
