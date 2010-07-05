function [np,nq]=%quad2d_size(th,opt)
// np : nombre de points
// nq : nombre de quadrangles
  [lhs,rhs]=argn(0);
  if rhs==1             
    np=size(th.Coor,'r'); 
    nq=size(th.Quad,'r');
  elseif convstr(opt,'l')=='c'
    np=size(th.Quad,'r');
  else
    error('Bad number of argument')
  end
  
endfunction
 
