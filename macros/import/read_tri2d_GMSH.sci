// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=read_tri2d_GMSH(nombase)
   // function to import automatically from file coming from gmsh
   
   u=file('open',nombase,'old');
   
   ligne=""
   while grep(ligne,"$MeshFormat")==[]
     ligne=read(u,1,1,'(a)');
   end
   version=read(u,1,1);
   
   while grep(ligne,"$Nodes")==[]
     ligne=read(u,1,1,'(a)');
   end
   nbvert=read(u,1,1);
   tmp=read(u,nbvert,4);
   if and(tmp(:,4)==0)
     th=tri2d('mesh file '+nombase+' '+date());
     th.Coor=tmp(:,2:3);
   else
     file('close',u);
     error('This GMSH file is a 3d mesh, use read_tet3d_GMSH function')
   end
   
   while grep(ligne,"$Elements")==[]
     ligne=read(u,1,1,'(a)')
   end
   nel=read(u,1,1);
   tmp=zeros(nel,9);
   for i=1:nel
     tt=evstr('['+read(u,1,1,'(a)')+']');
     tmp(i,1:length(tt))=tt;
   end
   
   file('close',u);

   iTri=tmp(:,2)==2;
   if version==2.1
     th.Tri=tmp(iTri,7:9);
   elseif version==2.2
     th.Tri=tmp(iTri,6:8);
   else
     error('GMSH Mesh Format unknown in read_tri2d_GMSH')
   end
   th.TriId=tmp(iTri,5)
   clear iTri
   
   iseg=tmp(:,2)==1;
   if version==2.1
     Ed=tmp(iseg,7:8);
   elseif version==2.2
     Ed=tmp(iseg,6:7);
   else
     error('GMSH Mesh Format unknown in read_tri2d_GMSH')
   end
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
	 k=find(ed(:,1)==bd(j-1));
	 bd(j)=ed(k,2);
       end
       th.Bnd(cpt)=bd; 
     end
   end


endfunction
