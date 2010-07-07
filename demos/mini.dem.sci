lines(0);
th=square2d(30,31);
u=p1_2d(th);
pb=edp(u);
pb.eq="-Laplace(u)=1";
assemble(pb);
lsolve(pb)