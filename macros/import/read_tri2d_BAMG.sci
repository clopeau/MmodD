// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=read_tri2d_BAMG(nombase)
   // import mesh from BAMG file
   // file extension .msh
   // 2d 

   th=tri2d(nombase);
   u=file('open',nombase,'old');
    //---- les points
   ligne=""

   while ligne~="Vertices"
     ligne=read(u,1,1,'(a)');
   end

   nbvert=read(u,1,1);
   tmp=read(u,nbvert,3);
   th.Coor=tmp(:,1:2);

   //----- les aretes
   ligne=""
   while ligne~="Edges"
     ligne=read(u,1,1,'(a)');
   end
   nbedge=read(u,1,1);
   tmp=read(u,nbedge,3);
   cpt=0
   th.BndId='f'+string(unique(tmp(:,3))');
   for i=unique(tmp(:,3))'
     cpt=cpt+1
     ind=find(tmp(:,3)==i)
     th.Bnd(cpt)=[tmp(ind,1);tmp(ind($),2)];
   end
   //----- les triangles
   ligne=""
   while ligne~="Triangles"
     ligne=read(u,1,1,'(a)');
   end
   nbtri=read(u,1,1);
   tmp=read(u,nbtri,4);
   // on ne récupere que le premier sous domaine !
   // attention 
   th.Tri=tmp(:,1:3);

   file('close',u);
   
endfunction
