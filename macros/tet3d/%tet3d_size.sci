// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [np,nt,nf]=%tet3d_size(th,opt)
// np : nombre de points
// nt : nombre de tringles
  [lhs,rhs]=argn(0);
  if rhs==1             
    np=size(th.Coor,'r'); 
    nt=size(th.Tet,'r');
    nf=size(th.Tri,'r');
  elseif convstr(opt,'l')=='c'
    np=size(th.Tet,'r');
  else
    error('Bad number of argument')
  end
  
endfunction
 
