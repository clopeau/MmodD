mode(-1);
// u doit etre une variable definie

pb=pde(u);
pb.eq='-Laplace(u)=8*%pi^2*sin(2*%pi*x)*sin(2*%pi*y)';
pb.E='Dn(u)=2*%pi*sin(2*%pi*y)';


sexacte='sin(2*%pi*x)*sin(2*%pi*y)';
