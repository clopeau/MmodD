// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %g=Grad_p1_2d(%u)
   %th=evstr(%u.geo);
   %g=p0(%th);
   %g.geo=%u.geo;
   [nf,nt]=size(%th);
   index=[2 3; 3 1; 1 2]';
   invdet=1 ./det(%th);
   
   Tmp1=zeros(nt,2)
   %g.Cell=zeros(nt,2)
   for i=1:3
     Tmp1(:,1)=(%th.Coor(%th.Tri(:,index(1,i)),2)-...
	 %th.Coor(%th.Tri(:,index(2,i)),2))...
	 .*%u.Node(%th.Tri(:,i)).*invdet;
     Tmp1(:,2)=(%th.Coor(%th.Tri(:,index(2,i)),1)-...
	 %th.Coor(%th.Tri(:,index(1,i)),1))...
	 .*%u.Node(%th.Tri(:,i)).*invdet;; 
 
     %g.Cell=%g.Cell+Tmp1
   end
endfunction
