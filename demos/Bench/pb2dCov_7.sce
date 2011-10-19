mode(-1);
// u doit etre une variable definie

v=p1(th,['1';'0'])
pb=pde(u);
pb.eq='-Laplace(u)+ConvGrad(v,u)=(8*%pi^2*sin(2*%pi*x)+2*%pi*cos(2*%pi*x))*sin(2*%pi*y)';

sexacte='sin(2*%pi*x)*sin(2*%pi*y)';
