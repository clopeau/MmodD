function %g=Grad_p1nc3d(%u)
   %th=evstr(%u.geo);
   %g=p0(%th);
   %g.geo=%u.geo;
   [n,nt,nf]=size(%th);
   index=[2 3; 3 1; 1 2]';
   lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
   //------------- Calcul du déterminant --------------------------------------
   invdet=27 ./det(%th);
   //-------------- Assemblage ------------------------------------------------
   XYZ=[x_tet3d_Face(%th),y_tet3d_Face(%th),z_tet3d_Face(%th)];
   
   Tmp1=zeros(nt,3); // 1 ere fct de base
   %g.Cell=zeros(nt,3)
   
   for i=1:4
     for k=1:3
       Tmp1(:,k)=(-1)^(i+1) *det2d(XYZ(:,index(:,k)),...
	   %th.Tet2Tri(:,lindex(i))).*%u.Face(%th.Tet2Tri(:,i))...
	   .*invdet;
     end   
     %g.Cell=%g.Cell+Tmp1
   end
