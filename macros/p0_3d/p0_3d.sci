function [out]=p0_3d(%th,%fonction)
// Fonction de definition generique de type "q1parallelle"
// Cell est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==0
     %nam=""
     %fonction="";
   elseif rhs==1
     %fonction="";
     %nam=name_mmodd(%th);
   else
     %nam=name_mmodd(%th);
   end
   
   out=mlist(['p0_3d';'#';'Id';'geo';'Cell'],rand(),%fonction,%nam,[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
