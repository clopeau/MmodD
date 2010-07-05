function B=kId_p1nc3d(%kk,%u)
     // matrice de masse sur tout le domaine
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
     tmp=abs(%th.Det).*%kk.Cell;
     for i=1:4
       Diag=Diag+sparse([%th.Tet2Tri(:,i),ones(nt,1)],tmp*cid,[nf,1]);
       for j=i+1:4
	 B=B+sparse(%th.Tet2Tri(:,[i j]),tmp*ci,[nf,nf])
       end
     end
     B=B+B'+diag(Diag)
endfunction
 
