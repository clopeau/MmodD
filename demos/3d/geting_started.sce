lines(0);
th3d=tcube3d(12,13,11);
u3d=p1(th3d);
pb3d=edp(u3d);
pb3d.eq="-Laplace(u3d)=1";
assemble(pb3d);
lsolve(pb3d)
