// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportSMESH(th)
   // format d'entre de GRUMMP
   [lhs,rhs]=argn(0)
   
   //netf='/tmp/netgem_'+part(string(rand(1)*1000000),1:6);
   netf='/tmp/grummp';
   u=file('open',netf+'.smesh','unknown')
   
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end
   
   fprintf(u,'poly %i %i\n',size(th),sum(ns))
   fprintf(u,'%f %f %f\n',th.Coor);

   //fprintf(u,'0');
    
   //fprintf(u,'%i',sum(ns));
   for i=1:length(th.Bnd)
     fprintf(u,'%i %i %i %i %i\n',3*ones(ns(i),1),...
	 th.Bnd(i)-1,i(ones(ns(i),1)));
   end

   
   file('close',u);
   
 endfunction
