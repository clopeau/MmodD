// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=%D(x,sig)
 n=length(x);
 
 ii=(1:n)';
 if sig=='+'
   invh=1 ./(x(1:$-1)-x(2:$));
   A=sparse(ii(1:$-1,[1 1]),invh,[n,n])...
       +sparse([ii(1:$-1),ii(2:$)],-invh,[n,n]);
 elseif sig=='-'
   invh=1 ./(x(1:$-1)-x(2:$));
   A=sparse(ii(2:$,[1 1]),-invh,[n,n])...
       +sparse([ii(2:$),ii(1:$-1)],invh,[n,n]);
 elseif sig=='c'
   invh=1 ./(2*(x(1:$-1)-x(2:$)));
   A=sparse(ii(1:$-1,[1 1]),invh,[n,n])+ ...
       sparse([ii(1:$-1),ii(2:$)],-invh,[n,n])+...
       sparse(ii(2:$,[1 1]),-invh,[n,n])+...
       sparse([ii(2:$),ii(1:$-1)],invh,[n,n]);
 end
 A(1,:)=0;
 A($,:)=0;
endfunction
