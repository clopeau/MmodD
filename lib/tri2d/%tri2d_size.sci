function [np,nt]=%tri2d_size(th,opt)
// np : nombre de points
// nt : nombre de tringles
  [lhs,rhs]=argn(0);
  if rhs==1             
    np=size(th.Coor,'r'); 
    nt=size(th.Tri,'r');
  elseif convstr(opt,'l')=='c'
    np=size(th.Tri,'r');
  else
    error('Bad number of argument')
  end
  
endfunction
 
