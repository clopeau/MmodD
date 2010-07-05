function [np,nf,npy]=%dcomp3d_size(th,opt)
// np : nombre de points
// nt : nombre de tringles
  [lhs,rhs]=argn(0);
  if rhs==1             
    np=size(th.Coor,'r'); 
    nf=length(th.Face);
    npy=length(th.Cell);
  elseif convstr(opt,'l')=='c'
    np=size(th.Face,'r');
  else
    error('Bad number of argument')
  end
  
endfunction
 
