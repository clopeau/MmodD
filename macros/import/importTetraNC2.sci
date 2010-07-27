// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=importTetraNC2(nombase)
  
  
   u=file('open',nombase,'unknown');
   th=tet3d(nombase)
   // n(1) : pts
   // n(2) : ntetra
   // n(3) : nfacefront
   n=read(u,1,4)
   // Lecture des Coordonnes
   th.Coor=read(u,n(1),3);
   tmp=read(u,n(2),5);
   th.Tet=tmp(:,1:4);
   th.TetId=tmp(:,5);
   clear tmp;
   th.Det=det(th);
   // Lecture des face
   th.Tri=read(u,n(3)+n(4),4)
   file('close',u);
   front=unique(th.Tri(1:n(3),4))';

   //front=front(front~=0);
   th.Tmp=[];
   for ii=1:length(front)
     th.BndiTri(ii)=find(th.Tri(1:n(3),4)==front(ii))';
     th.Bnd(ii)=th.Tri(th.BndiTri(ii),1:3);   
     th.Tmp(ii)=size(th.Bnd(ii),1);
   end
   th.BndId='f'+string(front);
   th.TriId=th.Tri(:,4);
   th.Tri(:,4)=[];
   th.size=[n(1),n(2),n(3)+n(4)];
   unix(%execu+'/tet2tri -i '+nombase+' -o '+nombase+'.t2t')
   u=file('open',nombase+'.t2t','unknown');
   th.Tet2Tri=read(u,-1,4);
   file('close',u);
   
   
   %ss=det(th)<0;
   th.Tet(%ss,[3 4])=th.Tet(%ss,[4 3]);
   th.Tet2Tri(%ss,[3 4])=th.Tet2Tri(%ss,[4 3]);  
   th.Det=abs(th.Det);
endfunction
 
