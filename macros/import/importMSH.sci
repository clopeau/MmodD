// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=importMSH(nombase)
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
     dim="2d"
   else
     th=tet3d('mesh file '+nombase+' '+date());
     th.Coor=tmp(:,2:4);
     dim="3d"
   end
   
   while grep(ligne,"$Elements")==[]
     ligne=read(u,1,1,'(a)')
     nbli=nbli+1;
   end
   nel=read(u,1,1);nbli=nbli+1;
   file('close',u);
   
   // Astuce pas très sympa...
   u=mopen(nombase)
   tmp=mgetl(u,nbli);
   tmp=mgetl(u,nel);
   mclose(u);
   
   
   //---------- Dimension 2 -----------
   if n==2
     //----- les aretes
     ligne=""
     while grep(ligne,"Edges")==[]|part(ligne,1)~='#'
       ligne=read(u,1,1,'(a)');
     end
     nbedge=read(u,1,1);
     tmp=read(u,nbedge,3);
     for i=1:nBnd
       ind=find(tmp(:,3)==i)
       th.Bnd(i)=[tmp(ind,1);tmp(ind($),2)];
     end
     
     //----- les triangles
     ligne=""
     while grep(ligne,"Triangles")==[]|part(ligne,1)=='#'
       ligne=read(u,1,1,'(a)');
     end
     nbtri=read(u,1,1);
     tmp=read(u,nbtri,4);
     // on ne récupere que le premier sous domaine !
     // attention 
     th.Tri=tmp(tmp(:,4)==1,1:3);
   
   // ---------- Dimension 3 -----------
   else
     //----- Triangles -------
     ligne=""
     while grep(ligne,"Triangles")==[]|part(ligne,1)=='#'
       ligne=read(u,1,1,'(a)');
     end
     nbtri=read(u,1,1);
     tmp=read(u,nbtri,4);
     ind=tmp(:,4);
     tmp=tmp(:,1:3);
     num=unique(ind);
     for i=1:length(num)
       th.BndId(i)=string(num(i));
       th.Bnd(i)=tmp(ind==num(i),:);
     end
     
     //----- les Tetra -------
     ligne=""
     while grep(ligne,"Tetrahedra")==[]|part(ligne,1)=='#'
       ligne=read(u,1,1,'(a)');
       if grep(ligne,'End')~=[]
         file('close',u);
         return
       end
     end
     nbtet=read(u,1,1);
     tmp=read(u,nbtet,5);
     th.Tet=tmp(:,1:4);

   end
   file('close',u);
   
endfunction
