function %u=Grad_q1p2d(%p)
   
   execstr('[nx,ny]=size('+%p.geo+')');
   x=evstr(%p.geo+'.x');
   y=evstr(%p.geo+'.y');

   %u=q1p2d(); %u.geo=%p.geo;
   
   D=%D(x,'c');
   h1=x(2)-x(1);
   h2=x(3)-x(2);
   h3=h1+h2;
   D(1,[1 2 3])=[h1^2-h3^2,h3^2,-h1^2]/(h1*h2*h3);
   h1=x($-1)-x($);
   h2=x($-2)-x($-1);
   h3=h1+h2;
   D($,[$-2 $-1 $])=[-h1^2,h3^2,h1^2-h3^2]/(h1*h2*h3);;

   %u.Node = (spdiag(ones(1:ny)).*.D)*%p.Node;
   
   D=%D(y,'c');
   h1=y(2)-y(1);
   h2=y(3)-y(2);
   h3=h1+h2;
   D(1,[1 2 3])=[h1^2-h3^2,h3^2,-h1^2]/(h1*h2*h3);
   h1=y($-1)-y($);
   h2=y($-2)-y($-1);
   h3=h1+h2;
   D($,[$-2 $-1 $])=[-h1^2,h3^2,h1^2-h3^2]/(h1*h2*h3);;

   %u.Node(:,2)= (D.*.spdiag(ones(1:nx)))*%p.Node;
   
endfunction
 
