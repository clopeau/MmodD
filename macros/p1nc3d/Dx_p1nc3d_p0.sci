function %A=Dx_p1nc3d_p0(%u)
   %th=evstr(%u.geo);
   [n,nt,nf]=size(%th);
   index=[2 3; 3 1; 1 2]';
   lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
   //------------- Calcul du déterminant --------------------------------------
   invdet=(27/6)*sign(det(%th));
   //-------------- Assemblage ------------------------------------------------
   XYZ=[x_tet3d_Face(%th),y_tet3d_Face(%th),z_tet3d_Face(%th)];
   
   tmp=zeros(nt,1); // 1 ere fct de base
   %A=spzeros(nf,nt)
   
   k=1
   ind=(1:nt)';
   for i=1:4
     tmp=(-1)^(i+1) *det2d(XYZ(:,index(:,k)),...
	 %th.Tet2Tri(:,lindex(i))).*invdet;
     %A=%A+sparse([%th.Tet2Tri(:,i),ind],tmp,[nf,nt]);
   end
 endfunction
