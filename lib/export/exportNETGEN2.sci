function exportNETGEN2(th)
   [lhs,rhs]=argn(0)
   
   //netf='/tmp/netgem_'+part(string(rand(1)*1000000),1:6);
   netf='/tmp/netgen';
   u=file('open',netf+'.surfacemesh','unknown')
   
   ns=zeros(1:length(th.Bnd));
   for i=1:length(th.Bnd)
     ns(i)=size(th.Bnd(i),1);
   end

   fprintf(u,'surfacemesh')
   fprintf(u,'%4.12f',h);
   fprintf(u,'%i',size(th));
   fprintf(u,'%3.12f %3.12f %3.12f\n',th.Coor)

   //fprintf(u,'0');
    
   fprintf(u,'%i',sum(ns));
   for i=1:length(th.Bnd)
     fprintf(u,'%i %i %i\n',th.Bnd(i));
   end
   
   //fprintf(u,'volumeelements');

   
   file('close',u);
   
 endfunction
