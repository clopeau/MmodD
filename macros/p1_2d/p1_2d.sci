// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out]=p1_2d(%th,%fonction)
// Type declaration
// 
// Calling Sequence
// p1_2d(th)
// p1_2d(th,fonction)
//
// Parameters
// th : a tri2d, a square2d etc
// function : a string ('x/2+y^2')
// Description
// p1_1_d is a list that contains 
//   Id : the p1_1d 's identity
//   Node : the p1_1d 's point coordinates
//
// Examples
// th = square2d(4,5)
// th.Id='my_th'
// p=p1_2d(th,'2*x^2 +y^3')
// p.Id
// p.Node
// p.geo
//
// See also 
// p1_2d
// square2d
// tri2d
// line3d
//
// Authors
// Clopeau T., Delanoue D., Ndeffo M. and Smatti S.

// Fonction de definition generique de type "q1parallelle"
// Node est le seul champ 
   [lhs,rhs]=argn(0);
   if rhs==0
     out=mlist(['p1_2d';'#';'Id';'geo';'Node';'Time'],rand(),"","",[],[]);
   elseif rhs==1
     %fonction="";
     out=mlist(['p1_2d';'#';'Id';'geo';'Node';'Time'],rand(),%fonction,name_mmodd(%th),[],[]);     
   elseif rhs==2
     out=mlist(['p1_2d';'#';'Id';'geo';'Node';'Time'],rand(),%fonction,name_mmodd(%th),[],[]);   
     interpol(out,%fonction);
   end
endfunction
