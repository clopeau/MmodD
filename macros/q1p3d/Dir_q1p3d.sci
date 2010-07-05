function bloc=Dir_q1p3d(u,Bnd,val);
     [lhs,rhs]=argn(0);
     G=evstr(u.geo);
     if rhs==2 then
       bloc=zeros(G(Bnd));
     else bloc=val*ones(G(Bnd));
     end
 endfunction
