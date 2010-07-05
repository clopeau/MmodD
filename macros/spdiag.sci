function out=spdiag(v,ndiag)
  [lhs,rhs]=argn(0)
  if rhs==1
    ndiag=0;
  end
  
  v=matrix(v,-1,1);
  m=length(v);
  n=m+abs(ndiag);
  if ndiag>0
    out=sparse([1:m ; ndiag+1:ndiag+m]',v,[n,n]);
  elseif ndiag<=0
    out=sparse([1-ndiag:m-ndiag ; 1:m]',v,[n,n]);
  end
endfunction
