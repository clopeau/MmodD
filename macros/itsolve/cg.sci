function [x,res,iter]=cg(A,b,eps)
  // 
  [lhs,rhs]=argn(0);
  if rhs==2
    eps=1e-7;
  end
  
  itermax=2000;
  [m,n]=size(A);
  //initialisation
  x=rand(length(full(b)),1);//zeros(full(b));//rand(length(full(b)),1);
  z=zeros(b);
  r=b-A*x;
  d=r;
  res=r'*r; plotres=res;
  iter=0;
  while (res>eps)&(iter<itermax)
    // iter
    iter=iter+1;
    // var interme
    z=A*d;
    alpha=res / (z' * d);
    x=x+alpha*d;
    r=r-alpha*z;
    res1=r'*r;
    Beta=res1/res;
    res=res1; plotres=[plotres,res];
    d=r+Beta*d;
  end
  if iter==itermax
    warning('Nombre maximal d''iteration dans GradConj')
    disp('Le residu est :')
    disp(res)
  end
  plot2d('nl',iter,plotres($),0)
endfunction

  
