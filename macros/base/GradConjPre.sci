function [x,res,iter]=GradConjPre(A,b,eps)
// Preconditionnement diagonal
// C matrice de preconditionnement somme des lignes
  [lhs,rhs]=argn(0);
  if rhs==2
    eps=1e-7;
  end
  
  itermax=1000;
  [m,n]=size(A);
  // Calcul du conditionnement
  [ij,v]=spget(A);
  C=1 ./v(ij(:,1)==ij(:,2));
  clear ij v
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
    beta=res1/res;
    res=res1; plotres=[plotres,res];
    p=-g+beta*p;
  end
  if iter==itermax
    warning('Nombre maximal d''iteration dans GradConj')
  end
//  semilogy(0:iter,plotres)
endfunction

  
