// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=read_tri2d_GMSH(nombase)
   // function to import automatically from file coming from gmsh
   
   u=file('open',nombase,'unknown');
   //u=mopen(nombase)
   //-----    Lecture de dimension : 2 ou 3d -----------
   nbli=0
   ligne=""
   while grep(ligne,"$Nodes")==[]
     ligne=read(u,1,1,'(a)');
     nbli=nbli+1;
   end
   nbvert=read(u,1,1);nbli=nbli+1;
   tmp=read(u,nbvert,4);nbli=nbli+nbvert;
   if and(tmp(:,4)==0)
     th=tri2d('mesh file '+nombase+' '+date());
     th.Coor=tmp(:,2:3);
   else
     file('close',u);
     error('This GMSH file is a 3d mesh, use read_tet3d_GMSH function')
   end
   
   while grep(ligne,"$Elements")==[]
     ligne=read(u,1,1,'(a)')
     nbli=nbli+1;
   end
   nel=read(u,1,1);nbli=nbli+1;
   tmp=zeros(nel,9);
   for i=1:nel
     tt=evstr('['+read(u,1,1,'(a)')+']');
     tmp(i,1:length(tt))=tt;
   end
   
   file('close',u);

   iTri=tmp(:,2)==2;
   th.Tri=tmp(iTri,7:9);
   th.TriId=tmp(iTri,5)
   clear iTri
   
   iseg=tmp(:,2)==1;
   Ed=tmp(iseg,7:8);
   edId=tmp(iseg,5);
   nbd=unique(edId);
   cpt=0;
   for i=nbd'
     cpt=cpt+1;
     th.BndId=[th.BndId "f"+string(i)];
     ed=Ed(edId==i,:);
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
       bd=zeros(length(a1)+1,1);
       bd(1)=ed(1,1);
       bd(2)=ed(1,2);
       for j=3:length(a1)+1;
	 k=find(ed(:,1)==bd(j-1))
	 bd(j)=ed(k,2);
       end
       th.Bnd(cpt)=bd; 
     end
   end


endfunction
