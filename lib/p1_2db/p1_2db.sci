function [out]=p1_2db(%th,%fonction)
// Fonction de definition generique de type "q1parallele"
// 2 champs Node et Cell 
   [lhs,rhs]=argn(0);
   if rhs==1
     %fonction="";
   end
   out=mlist(['p1_2db';'#';'Id';'geo';'Node';'Cell'],rand(),%fonction,name(%th),[],[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
