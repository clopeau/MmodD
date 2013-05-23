// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function exportSMESH2(th)
// export vres GRUMMp
   [lhs,rhs]=argn(0)
   
   //netf='/tmp/netgem_'+part(string(rand(1)*1000000),1:6);
   netf='/tmp/grummp';
   u=mopen(netf+'.smesh','wt')
   
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end
   
   mfprintf(u,'face %i %i\n',size(th),sum(ns))
   mfprintf(u,'%f %f %f\n',th.Coor);

   //fprintf(u,'0');
    
   //fprintf(u,'%i',sum(ns));
   for i=1:length(th.Bnd)
     mfprintf(u,'%i %i %i %i %i\n',3*ones(ns(i),1),...
	 th.Bnd(i)-1,i(ones(ns(i),1)));
   end

   
   mclose(u);
   
 endfunction
 
