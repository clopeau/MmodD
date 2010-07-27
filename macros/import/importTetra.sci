// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function th=importTetra(nombase)
  
  
   u=file('open',nombase,'unknown');
   th=tet3d(nombase)
   // n(1) : pts
   // n(2) : ntetra
   // n(3) : nfacefront
   n=read(u,1,3)
   // Lecture des Coordonnes
   th.Coor=read(u,n(1),3);
   tmp=read(u,n(2),5);
   th.Tet=tmp(:,1:4);
   th.TetId=tmp(:,5);
   // Lecture des face
   tmp=read(u,n(3),4)
   front=unique(tmp(:,4))';
   front=front(front~=0);
   for ii=1:length(front)
     th.Bnd(ii)=tmp(tmp(:,4)==front(ii),1:3);   
   end

   file('close',u);
   th.BndId='f'+string(front);

   %ss=det(th)<0;
   th.Tet(%ss,[3 4])=th.Tet(%ss,[4 3]);
   
endfunction
 
