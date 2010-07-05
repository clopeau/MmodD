exec ../../../loader.sce

n=10;
g=grid3d(n+1,n,n-2);
u=df3d(g)
pb=edp(u)
pb.eq="-Laplace(u)=1"
assemble(pb)
x=zeros(pb.b);
//[L,U]=ilut(pb.A);
//disp(size(U));
//[x,ierr]=pgmres(pb.A,pb.b,zeros(pb.b),1000,1e-13,40,10)
[x,ierr]=pgc(pb.A,pb.b,zeros(pb.b),1000,1e-13,15)
//x=pcg(pb.A,pb.b)
u.Node=x;
//paraview(u)
