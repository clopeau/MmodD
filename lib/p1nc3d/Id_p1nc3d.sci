function B=Id_p1nc3d(%u,opt)
   [lhs,rhs]=argn(0);
   if rhs==1 then
     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     %th=evstr(%u.geo);
     nn=%th.size(1);
     nt=%th.size(2);
     nf=%th.size(3);
     //index=[2 3; 3 1; 1 2]';
     ci=-1/120; 
     cid=8/120; 
     //------------- Calcul du déterminant ------------------------
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:4
       Diag=Diag+sparse([%th.Tet2Tri(:,i),ones(nt,1)],abs(%th.Det)*cid,[nf,1]);
       for j=i+1:4
	 B=B+sparse(%th.Tet2Tri(:,[i j]),abs(%th.Det)*ci,[nf,nf])
       end
     end
     B=B+B'+diag(Diag)
   else
     %mh=evstr(%u.geo);
     [n,n,nf]=size(%mh)
     //Coor=evstr(%u.geo+'.Coor');
     Tri=%mh(opt)
     nt=size(Tri,1)
     //tmp=unique(tri);
     
     p=%mh.Coor(Tri(:,2),:)-%mh.Coor(Tri(:,1),:);
     q=%mh.Coor(Tri(:,3),:)-%mh.Coor(Tri(:,1),:);
     Det=p(:,[2 3 1]).*q(:,[3 1 2]) - p(:,[3 1 2]).*q(:,[2 3 1]);
     clear p q;
     Det=sqrt(sum(Det.^2,'c'))/2;
     
     B=spzeros(nf,nf);
     i=find(%mh.BndId==opt)
     ind=%mh.BndiTri(i);
     B=B+sparse(ind(:,[1,1]),Det,[nf,nf])

   end
endfunction
 
