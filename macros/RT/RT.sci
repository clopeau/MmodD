function [out]=RT(%th,%fonction)
// Fonction de definition generique de type "Raviart-Thomas"
// Face est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==1
     %fonction="";
   end
   out=mlist(['RT';'#';'Id';'geo';'Face'],rand(),%fonction,name(%th),[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
