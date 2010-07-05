function [out]=p1nc3d(%th,%fonction)
// Face est le seul champ 
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
   
   out=mlist(['p1nc3d';'#';'Id';'geo';'Face'],rand(),%fonction,%nam,[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
