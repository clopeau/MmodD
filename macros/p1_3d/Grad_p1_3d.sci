function %g=Grad_p1_3d(%u)
   %th=evstr(%u.geo);
   %g=p0(%th);
   %g.geo=%u.geo;
   [nf,nt]=size(%th);
   index=[2 3; 3 1; 1 2]';
   lindex=list([2 3 4],[1 3 4],[1 2 4],[1 2 3]);
   invdet=1 ./det(%th);
   
   Tmp1=zeros(nt,3)
   %g.Cell=zeros(nt,3)
   for i=1:4
     for k=1:3
       Tmp1(:,k)=(-1)^(i) ...
	   *det2d(%th.Coor(:,index(:,k)),%th.Tet(:,lindex(i)))...
	   .*%u.Node(%th.Tet(:,i)).*invdet;
     end   
     %g.Cell=%g.Cell+Tmp1
   end
