function exportNETGEN(th)
   [lhs,rhs]=argn(0)
   
   //netf='/tmp/netgem_'+part(string(rand(1)*1000000),1:6);
   netf='/tmp/netgen';
   u=file('open',netf+'.geo','unknown')
   fprintf(u,'mesh3d')
 //   file('close',u);
   fprintf(u,'surfaceelements');
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end
   fprintf(u,'%i',sum(ns));
   for i=1:length(th.Bnd)
     fprintf(u,'%i %i %i %i %i %i %i\n',...
	 i(ones(ns(i),1)),ones(ns(i),1),ones(ns(i),1),2*ones(ns(i),1),...
	 th.Bnd(i));
   end
   
   fprintf(u,'volumeelements');
   fprintf(u,'0');

   fprintf(u,'points');
   fprintf(u,'%i',size(th));
   fprintf(u,'%3.12f %3.12f %3.12f\n',th.Coor)
   
   
   file('close',u);
   
 endfunction
 
