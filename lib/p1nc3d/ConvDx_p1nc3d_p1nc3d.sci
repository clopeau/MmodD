function %A=ConvDx_p1nc3d_p1nc3d(%u,%c)
   %th=evstr(%c.geo);
   [n,nt,nf]=size(%th);
   index=[2 3; 3 1; 1 2]';
   lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
   //------------- Calcul du déterminant --------------------------------------
   invdet=(27)*sign(det(%th));
   //-------------- Assemblage ------------------------------------------------
   XYZ=[x_tet3d_Face(%th),y_tet3d_Face(%th),z_tet3d_Face(%th)];
   
   tmp=zeros(nt,1); // fct de base du la convection u
   tmp2=zeros(nt,1)
   %A=spzeros(nf,nf)
   ci=-1/120; // terme extra diag de la matrice de masse
   cid=8/120; // term diag
   //------------- Calcul du déterminant ------------------------
     
   k=1  // !!!!!!!!
   for j=1:4
     //  Diag=Diag+sparse([%th.Tet2Tri(:,i),ones(nt,1)],Det*cid,[nf,1]);
     tmp=(-1)^(j+1) *det2d(XYZ(:,index(:,k)),...
	 %th.Tet2Tri(:,lindex(j))).*invdet;
     for i=1:4
       tmp2=zeros(nt,1)
       for l=1:4
	 if l==j
	   cc=cid;
	 else
	   cc=ci
	 end
	 tmp2=tmp2+cc*%u.Face(%th.Tet2Tri(:,l))
       end
       %A=%A+sparse(%th.Tet2Tri(:,[i j]),tmp.*tmp2,[nf,nf])
     end
   end

 endfunction
