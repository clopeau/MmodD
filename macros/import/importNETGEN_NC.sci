// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=importNETGEN_NC(nombase)
    // lecture des fichiers de sortie NETGEN 4.3
    // fichier nombase.vol
    //
    th=importNETGEN(nombase)
    u=file('open',nombase+'.t2t.in','unknown');
    
    nTet=size(th.Tet,1);
    nTri=0;
    for Fr=th.Bnd
      nTri=nTri+size(Fr,1);
    end
    fprintf(u,'%i %i\n',nTet,nTri);
    fprintf(u,'%i %i %i %i\n',th.Tet);
    
    ind=0
    for  Fr=th.Bnd
      ind=ind+1;
      fprintf(u,'%i %i %i %i\n',Fr,ind*ones(size(Fr,1),1));
    end  
    
    file('close',u);
    
    unix(%execu+'tet2tri2 -i '+nombase+'.t2t.in -o '+nombase+'.t2t.out')
    
    u=file('open',nombase+'.t2t.out','unknown');
    nn=read(u,1,2)
    
    th.Tet2Tri=read(u,nn(1),4);
    tmp=read(u,nn(2),4);
    th.Tri =  tmp(:,1:3);
    th.TriId =tmp(:,4);
    file('close',u);
    unix('rm -f '+nombase+'.t2t.in '+nombase+'.t2t.out')
    
    cpt=1;
    for i=th.Bnd
      th.BndiTri(cpt)=find(th.TriId==cpt)';
      cpt=cpt+1;
    end
    [a,b,c]=size(th)
    th.size=[a b c]
    th.Det=det(th);
    
endfunction
  
