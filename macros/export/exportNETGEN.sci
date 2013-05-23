// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportNETGEN(th)
   [lhs,rhs]=argn(0)
   
   //netf='/tmp/netgem_'+part(string(rand(1)*1000000),1:6);
   netf='/tmp/netgen';
   u=mopen(netf+'.geo','wt')
   mfprintf(u,'mesh3d')
 //   file('close',u);
   mfprintf(u,'surfaceelements\n');
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end
   mfprintf(u,'%i\n',sum(ns));
   for i=1:length(th.Bnd)
     mfprintf(u,'%i %i %i %i %i %i %i\n',...
	 i(ones(ns(i),1)),ones(ns(i),1),ones(ns(i),1),2*ones(ns(i),1),...
	 th.Bnd(i));
   end
   
   mfprintf(u,'volumeelements\n');
   mfprintf(u,'0\n');

   mfprintf(u,'points\n');
   mfprintf(u,'%i\n',size(th));
   mfprintf(u,'%3.12f %3.12f %3.12f\n',th.Coor)
   
   
   mclose(u);
   
 endfunction
 
