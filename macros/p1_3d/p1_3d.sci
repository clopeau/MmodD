// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out]=p1_3d(%th,%fonction)
// Fonction de definition generique de type "q1parallelle"
// Node est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==1
     %fonction="";
   end
   out=mlist(['p1_3d';'#';'Id';'geo';'Node'],rand(),%fonction,name(%th),[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
