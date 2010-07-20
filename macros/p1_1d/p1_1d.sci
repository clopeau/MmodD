function [out]=p1_1d(%th,%fonction)
// Type declaration
// 
// Calling Sequence
// p1_1d(th)
// p1_1d(th,fonction)
//
// Parameters
// th : a tri2d, a square2d etc
// function : a string ('x/2')
//
// Description
// p1_1_d is a list that contains 
//   Id : the p1_1d 's identity
//   Node : the p1_1d 's point coordinates
//
// Examples
// th = square2d(4,5)
// th.Id='my_th'
// p=p1_1d(th,'2*x^2')
// p.Id
// p.Node
// p.geo
//
// See also 
// p1_2d
// square2d
// tri2d

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
   
   out=mlist(['p1_1d';'#';'Id';'geo';'Node'],rand(),%fonction,%nam,[]);   
   if rhs==2
     interpol(out,%fonction);
   end
endfunction
