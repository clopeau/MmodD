exec ../../../loader.sce

n=50;
g=grid3d(n+1,n,n-2);
u=df3d(g)
pb=edp(u)
pb.eq="-Laplace(u)=1"
assemble(pb)
x=zeros(pb.b);
//[L,U]=ilut(pb.A);
//disp(size(U));
//[x,ierr]=pgmres(pb.A,pb.b,zeros(pb.b),1000,1e-13,10,4,0.0001);
//[x,ierr]=pgc(pb.A,pb.b,zeros(pb.b),1000,1e-13,5,0.0001);
//[x,ierr]=pgcnr(pb.A,pb.b,zeros(pb.b),1000,1e-13,5);
//[x,ierr]=pbgc(pb.A,pb.b,zeros(pb.b),1000,1e-13,5);
//[x,ierr]=pdbgc(pb.A,pb.b,zeros(pb.b),1000,1e-13,5);
//[x,ierr]=pbcgstab(pb.A,pb.b,zeros(pb.b),1000,1e-10,10,0.0001);
disp('on entre')
//[x,ierr]=pqmr(pb.A,pb.b,zeros(pb.b),1000,1e-10,10,0.0001);
[x,ierr]=shurgmres(pb.A,pb.b,zeros(pb.b),1000,1e-13,5,4,0.0001);


//x=pcg(pb.A,pb.b)
//u.Node=x;
//paraview(u)
