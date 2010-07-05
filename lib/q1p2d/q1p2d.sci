function [out]=q1p2d(%th,%fonction)
// Fonction de definition generique de type "q1parallelle"
// Node est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==0
     %nam=""
     %fonction="";
   elseif rhs==1
     %fonction="";
     %nam=name(%th);
   else
     %nam=name(%th);
   end
   
   out=mlist(['q1p2d';'#';'Id';'geo';'Node'],rand(),%fonction,%nam,[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
