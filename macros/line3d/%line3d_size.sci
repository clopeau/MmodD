function [np,nt]=%line3d_size(th,opt)
// np : nombre de points
// nt : nombre de tringles
  [lhs,rhs]=argn(0);
  if rhs==1             
    np=size(th.Coor,'r'); 
    nt=size(th.Seg,'r')-1;
  elseif convstr(opt,'l')=='c'
    np=size(th.Seg,'r')-1;
  else
    error('Bad number of argument')
  end
  
endfunction
 
