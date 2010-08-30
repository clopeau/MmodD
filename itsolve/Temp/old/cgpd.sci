function [x,res,iter]=cgpd(A,b,eps)
// Preconditionnement diagonal
// C matrice de preconditionnement somme des lignes
  [lhs,rhs]=argn(0);
  if rhs==2
    eps=1e-7;
  end
  
  itermax=5000;
  [m,n]=size(A);
  // Calcul du preconditionnement
  C=1 ./full(diag(A));
  //initialisation
  x=rand(1:length(full(b)))';
  z=zeros(x);
  r=A*x-full(b);
  g=C.*r;
  p=-g;
  res=r'*g; plotres=res;
  iter=0;
  while (res>eps)&(iter<itermax)
    // iter
    iter=iter+1;
    // var interme
    z=A*p;
    alpha=res / (p' * z);
    x=x+alpha*p;
    r=r+alpha*z;
    g=C.*r;
    res1=r'*g;
    Beta=res1/res;
    res=res1; plotres=[plotres,res];
    p=-g+Beta*p;
    plot2d('nl',iter,plotres($),0)
  end
  if iter==itermax
    warning('Nombre maximal d''iteration dans GradConj')
  end

endfunction

  
