function [out]=q1_3d(%th,%fonction)
// Fonction de definition generique de type "q1parallelle"
// Node est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==1
     %fonction="";
   end
   out=mlist(['q1_3d';'#';'Id';'geo';'Node'],rand(),%fonction,name(%th),[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
