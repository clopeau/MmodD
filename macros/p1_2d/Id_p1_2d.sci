// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=Id_p1_2d(%u,opt)
   [lhs,rhs]=argn(0);
   if rhs==1 then
     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     %th=%u.geo;
     execstr('[nf,nt]=size('+%th+')');
     index=[2 3; 3 1; 1 2]';
     ci=1/24; 
     cid=1/12; 
	     
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:3
       execstr('Diag=Diag+sparse(['+%th+'.Tri(:,i),ones(nt,1)],'+%th+'.Det*cid,[nf,1])');
       for j=i+1:3
	execstr('B=B+sparse('+%th+'.Tri(:,[i j]),'+%th+'.Det*ci,[nf,nf])')
       end
     end
     B=B+B'+diag(Diag)
   else
     Matel=[1/3 1/6 ; 1/6 1/3];
     %th=%u.geo
     ntot=evstr('size('+%th+')');
     //-- recherche du numéro de frontiere ---
     l=1, n=evstr('size('+%th+'.BndId,''*'')');
     while evstr(%th+'.BndId(l)')~=opt
       l=l+1
       if l>n
	 error('Bad BndId in Id_p1_2d')
	 return
       end
     end
     execstr('ind='+%th+'.Bnd(l)');
     ni=length(ind)-evstr(%th+'.BndPerio(l)');
     B=spzeros(ntot,ntot);
     execstr('long=sqrt(sum(('+%th+'.Coor(ind(1:$-1),:)-'+%th+'.Coor(ind(2:$),:)).^2,''c''))');
     
     for i=1:2
       for j=1:2
	 B=B+sparse([ind(i:$+i-2),ind(j:$+j-2)],long*Matel(i,j),[ntot,ntot]) 
       end
     end

   end
 endfunction
 
