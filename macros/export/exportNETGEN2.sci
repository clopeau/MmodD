// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportNETGEN2(th)
   [lhs,rhs]=argn(0)
   
   //netf='/tmp/netgem_'+part(string(rand(1)*1000000),1:6);
   netf='/tmp/netgen';
   u=mopen(netf+'.surfacemesh','wt')
   
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end

   mfprintf(u,'surfacemesh\n')
   mfprintf(u,'%4.12f\n',h);
   mfprintf(u,'%i\n',size(th));
   mfprintf(u,'%3.12f %3.12f %3.12f\n',th.Coor)

   //fprintf(u,'0');
    
   mfprintf(u,'%i\n',sum(ns));
   for i=1:length(th.Bnd)
     mfprintf(u,'%i %i %i\n',th.Bnd(i));
   end
   
   //fprintf(u,'volumeelements');

   
   mclose(u);
   
 endfunction
