mode(-1);
// u doit etre une variable definie

pb=pde(u);
pb.eq='-Laplace(u)+Dy(u)=(8*%pi^2*sin(2*%pi*y)+2*%pi*cos(2*%pi*y))*sin(2*%pi*x)';

sexacte='sin(2*%pi*x)*sin(2*%pi*y)';
