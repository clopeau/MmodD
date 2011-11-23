// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out,%th]=p1_3d(%th,%fonction)
// Fonction de definition generique de type "q1parallelle"
// Node est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==0
     out=mlist(['p1_3d';'#';'Id';'geo';'Node';'Time'],rand(),"","",[],[]);
   elseif rhs==1
     %fonction="";
     out=mlist(['p1_3d';'#';'Id';'geo';'Node';'Time'],rand(),%fonction,name_mmodd(%th),[],[]);     
   elseif rhs==2
     out=mlist(['p1_3d';'#';'Id';'geo';'Node';'Time'],rand(),%fonction,name_mmodd(%th),[],[]);   
     interpol(out,%fonction);
   end
   
    // Base Completion
   if %th.Det==[] | size(%th.Det,1)~=size(%th.Tet,1)
     %th.Det=det(%th);
     [nf,nt]=size(%th);

     index=[2 3; 3 1; 1 2]';
     lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
     Tmp=zeros(nt,3);
     for i=1:4
       for k=1:3
	 Tmp(:,k)=(-1)^(i+1) *det2d(%th.Coor(:,index(:,k)),%th.Tet(:,lindex(i)));
       end
       %th.Shape_p1_Grad(i)=Tmp;
     end
     clear Tmp  
     if lhs<=1
       execstr('['+name_mmodd(%th)+']=return(%th);');
     end
   end
 endfunction
