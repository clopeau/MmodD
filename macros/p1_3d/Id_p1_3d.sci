// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=Id_p1_3d(%u,opt)
   [lhs,rhs]=argn(0);
   if rhs==1 then
     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     %th=evstr(%u.geo);
     [nf,nt]=size(%th);
     //index=[2 3; 3 1; 1 2]';
     ci=1/20; 
     cid=1/10; 
     //------------- Calcul du déterminant ------------------------
     Det=abs(det(%th))/6;
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:4
       Diag=Diag+sparse([%th.Tet(:,i),ones(nt,1)],Det*cid,[nf,1]);
       for j=i+1:4
	 B=B+sparse(%th.Tet(:,[i j]),Det*ci,[nf,nf])
       end
     end
     B=B+B'+diag(Diag)
   else
     ci=1/24; 
     cid=1/12; 
     %mh=evstr(%u.geo);
     nf=size(%mh)
     //Coor=evstr(%u.geo+'.Coor');
     Tri=%mh(opt)
     nt=size(Tri,1)
     //tmp=unique(tri);
     
     p=%mh.Coor(Tri(:,2),:)-%mh.Coor(Tri(:,1),:);
     q=%mh.Coor(Tri(:,3),:)-%mh.Coor(Tri(:,1),:);
     Det=p(:,[2 3 1]).*q(:,[3 1 2]) - p(:,[3 1 2]).*q(:,[2 3 1]);
     clear p q;
     Det=sqrt(sum(Det.^2,'c'));
     
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:3
       Diag=Diag+sparse([Tri(:,i),ones(nt,1)],Det*cid,[nf,1]);
       for j=i+1:3
         B=B+sparse(Tri(:,[i j]),Det*ci,[nf,nf])
       end
     end
     B=B+B'+diag(Diag)

   end
endfunction
 
