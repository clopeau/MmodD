// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportTETGEN(fname,th)
   // exporte a partir d un maillage decomposition polhedrique dans tetgen
   // Tetgen 1.3 .node .face .ele

   //------------  preambule ------------

   [np,nt]=size(th);
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end
 

   //-------- node
   u=file('open',fname+'.node','unknown')
//   if length(th.CoorId)==0
     fprintf(u,'%i 3 0 0',np);
     fprintf(u,'%i %3.12f %3.12f %3.12f\n',(1:np)',th.Coor);
//   else
//     fprintf(u,'%i 3 1 0',np);
//     fprintf(u,'%i %3.12f %3.12f %3.12f %i\n',(1:np)',th.Coor,th.CoorId);
//   end
   file('close',u);

   //--------- face
   u=file('open',fname+'.face','unknown')
   fprintf(u,'%i 1',sum(ns));
   for i=1:length(th.Bnd)
     ind=(sum(ns(1:i-1))+1:sum(ns(1:i)))';
     fprintf(u,'%i %i %i %i %i\n',ind,th.Bnd(i),i*ones(ind));
   end
   file('close',u);
   
   //--------- ele
   u=file('open',fname+'.ele','unknown')
   if length(th.TetId)==0
     fprintf(u,'%i 4 0',nt);
     fprintf(u,'%i %i %i %i %i\n',(1:nt)',th.Tet);
   else
     fprintf(u,'%i 4 0',nt);
     fprintf(u,'%i %i %i %i %i %i\n',(1:nt)',th.Tet,th.TetId);
   end
   
   file('close',u);
     
   
endfunction
 
