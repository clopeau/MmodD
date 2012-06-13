// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=Id_p1_3d(%u,opt)
   [lhs,rhs]=argn(0);
   if rhs==1 then
     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     %th=%u.geo;
     execstr('[nf,nt]=size('+%th+')');
     //index=[2 3; 3 1; 1 2]';
     ci=1/20; 
     cid=1/10; 
     //------------- Calcul du déterminant ------------------------
     execstr('Det=abs('+%th+'.Det)/6');
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:4
       execstr('Diag=Diag+fastsparse(['+%th+'.Tet(:,i),ones(nt,1)],Det*cid,[nf,1])');
       for j=i+1:4
	 execstr('B=B+fastsparse('+%th+'.Tet(:,[i j]),Det*ci,[nf,nf])');
       end
     end
     B=B+B'+diag(Diag)
   else
     ci=1/24; 
     cid=1/12; 
     %mh=%u.geo;
     execstr('nf=size('+%mh+')');
     //Coor=evstr(%u.geo+'.Coor');
     execstr('Tri='+%mh+'(opt)')
     nt=size(Tri,1)
     //tmp=unique(tri);
     
     execstr('p='+%mh+'.Coor(Tri(:,2),:)-'+%mh+'.Coor(Tri(:,1),:)');
     execstr('q='+%mh+'.Coor(Tri(:,3),:)-'+%mh+'.Coor(Tri(:,1),:)');
     Det=p(:,[2 3 1]).*q(:,[3 1 2]) - p(:,[3 1 2]).*q(:,[2 3 1]);
     clear p q;
     Det=sqrt(sum(Det.^2,'c'));
     
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:3
       Diag=Diag+fastsparse([Tri(:,i),ones(nt,1)],Det*cid,[nf,1]);
       for j=i+1:3
         B=B+fastsparse(Tri(:,[i j]),Det*ci,[nf,nf])
       end
     end
     B=B+B'+diag(Diag)

   end
endfunction
 
