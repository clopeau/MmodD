// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=read_tet3d_GMSH(nombase)
   // function to import automatically from file coming from gmsh
   
   u=file('open',nombase,'old');
   //u=mopen(nombase)
   //-----    Lecture de dimension : 2 ou 3d -----------
   nbli=0
   ligne=""
   while grep(ligne,"$Nodes")==[]
     ligne=read(u,1,1,'(a)');
     nbli=nbli+1;
   end
   nbvert=read(u,1,1);nbli=nbli+1;
   tmp=read(u,nbvert,4);
   if and(tmp(:,4)==0)
     file('close',u);
     error('This GMSH file is a 2d mesh, use read_tri2d_GMSH function')
   else
     th=tet3d('mesh file '+nombase+' '+date());
     th.Coor=tmp(:,2:4);
   end
   
   while grep(ligne,"$Elements")==[]
     ligne=read(u,1,1,'(a)')
     nbli=nbli+1;
   end
   nel=read(u,1,1);nbli=nbli+1;
   tmp=zeros(nel,10);
   for i=1:nel
     tt=evstr('['+read(u,1,1,'(a)')+']');
     tmp(i,1:length(tt))=tt;
   end
   
   file('close',u);

   iTet=tmp(:,2)==4;
   th.Tet=tmp(iTet,7:10);
   th.TetId=tmp(iTet,5);
   clear iTet
   
   iTri=tmp(:,2)==2;
   Tri=tmp(iTri,7:9);
   TriId=tmp(iTri,5);
   nbd=unique(TriId);
   cpt=0;
   for i=nbd'
     cpt=cpt+1;
     th.BndId=[th.BndId "f"+string(i)];
     th.Bnd(cpt)=Tri(TriId==i,:); 
   end


endfunction
