// Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [np,ne]=%edge1d_size(th,opt)
// np : nomber of points
// ne : nomber of edges
  [lhs,rhs]=argn(0);
  if rhs==1             
    np=size(th.Coor,'r'); 
    ne=size(th.Ed,'r');
  elseif convstr(opt,'l')=='c'
    np=size(th.Ed,'r');
  else
    error('Bad number of argument')
  end
  
endfunction
 
