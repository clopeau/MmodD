lines(0);
th=square2d(12,13);
u=p1_2d(th);
pb=pde(u);
pb.eq="-Laplace(u)=1";
assemble(pb);
lsolve(pb)
