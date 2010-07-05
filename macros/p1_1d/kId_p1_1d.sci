function M = kId_p1_1d(%kk,%u,opt)
   [lhs,rhs]=argn(0);
   if rhs==2 then
     if typeof(%kk)=='p1_1d'
       %kk=p0(%kk);
     end
     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     execstr('nx=size('+%u.geo+')');
     h=evstr(%u.geo+'(''x'')');
     h=h(2:$)-h(1:$-1);
     h=h.*%kk.Cell/4;
     
     M=spzeros(nx,nx);
  
     M=spdiag([h;0])+spdiag([0;h])+spdiag(h,1)+spdiag(h,-1);

   else
     // condition aux limites
     %th=evstr(%u.geo);
     ntot=size(%th);
     l=1, n=size(%th.BndId,'*')
     while %th.BndId(l)~=opt
       l=l+1
       if l>n
	 error('Bad BndId in Id_p1_1d')
	 return
       end
     end
     ind=%th.Bnd(l);
     M=spzeros(ntot,ntot);
     M(ind,ind)=1;
   end
  
endfunction
