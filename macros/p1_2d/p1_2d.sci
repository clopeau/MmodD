// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out,%th]=p1_2d(%th,%fonction,%domain)
// Node est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==0
     out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'Time']..
	 ,rand(),"","",[],[],[],[]);
   elseif rhs==1
     %fonction="";
     out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'Time']..
	 ,rand(),%fonction,name_mmodd(%th),[],[],[],[]);     
   elseif rhs==2 & ~exists('domain','local')
     out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'Time']..
	 ,rand(),%fonction,name_mmodd(%th),[],[],[],[]);  
     interpol(out,%fonction);
   elseif rhs==2 & exists('domain','local')
     %ind=~ones(size(%th),1);
     for i=1:length(domain)
       %ind(matrix(%th.Tri(%th.TriId==domain(i),:),-1,1))=%t;
      end
     out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'Time']..
	 ,rand(),"",name_mmodd(%th),domain,[],%ind,[]);
   else
     out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'Time']..
	 ,rand(),%fonction,name_mmodd(%th),domain,[],[],[]);
     interpol(out,%fonction);
   end
   
   // Base Completion
   if %th.Det==[] | size(%th.Det,1)~=size(%th.Tri,1)
     %th.Det=det(%th);
     [nf,nt]=size(%th);

     if typeof(%th)=='tri2d'
       index=[2 3; 3 1; 1 2]';
       Tmp=zeros(nt,2);
       for i=1:3
	 Tmp(:,1)=%th.Coor(%th.Tri(:,index(1,i)),2)-...
		  %th.Coor(%th.Tri(:,index(2,i)),2);
	 Tmp(:,2)=%th.Coor(%th.Tri(:,index(2,i)),1)-...
		  %th.Coor(%th.Tri(:,index(1,i)),1); 
	 %th.Shape_p1_Grad(i)=Tmp;
       end
       //else  // typeof(%th)=='tri3d'
       //  error('---- To be defined !!!!! -------')
     end
     
     if lhs<=1
       execstr('['+name_mmodd(%th)+']=return(%th);');
     end
   end
endfunction
