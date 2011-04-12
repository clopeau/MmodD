// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %A=ConvDz_p1_3d_p1_3d(%u,%c)
   %th=evstr(%c.geo);
   [n,nt]=size(%th);
   index=[2 3; 3 1; 1 2]';
   lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
   //------------- Calcul du déterminant --------------------------------------
   //invdet=sign(det(%th));
   //-------------- Assemblage ------------------------------------------------
   
   tmp=zeros(nt,1); // fct de base du la convection u
   tmp2=zeros(nt,1)
   %A=spzeros(n,n)
   ci=1/120; // terme extra diag de la matrice de masse
   cid=1/60; // term diag
   //------------- Calcul du déterminant ------------------------
     
   k=3  // !!!!!!!!
   for j=1:4
     tmp=(-1)^(j)*det2d(%th.Coor(:,index(:,k)),%th.Tet(:,lindex(j)))
     //.*invdet;
     for i=1:4
       tmp2=zeros(nt,1)
       for l=1:4
	 if l==j
	   cc=cid;
	 else
	   cc=ci
	 end
	 tmp2=tmp2+cc*%u.Node(%th.Tet(:,l))
       end
       %A=%A+sparse(%th.Tet(:,[i j]),tmp.*tmp2,[n,n])
     end
   end

 endfunction
