function B=kId_p1_2d(%kk,%u)
    if typeof(%kk)=='p1_2d'
      %kk=p0(%kk)
    end

     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     %th=evstr(%u.geo);
     [nf,nt]=size(%th);
     index=[2 3; 3 1; 1 2]';
     ci=1/24; 
     cid=1/12; 
	
     //------------- Calcul du déterminant ------------------------
     Det=zeros(nt,1);
     tmp=zeros(nt,1);
     for i=1:3
       tmp=%th.Coor(%th.Tri(:,index(1,i)),2)-...
	   %th.Coor(%th.Tri(:,index(2,i)),2);
       Det=Det+%th.Coor(%th.Tri(:,i),1).*tmp;
     end
     Det=Det.*%kk.Cell;
     
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:3
       Diag=Diag+sparse([%th.Tri(:,i),ones(nt,1)],Det*cid,[nf,1]);
       for j=i+1:3
	 B=B+sparse(%th.Tri(:,[i j]),Det*ci,[nf,nf])
       end
     end
     B=B+B'+diag(Diag)

 endfunction
 
