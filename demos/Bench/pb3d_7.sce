mode(-1);
// u doit etre une variable definie

pb=pde(u);
pb.eq='-Laplace(u)=12*%pi^2*sin(2*%pi*x)*sin(2*%pi*y)*sin(2*%pi*z)';
pb.D='Dn(u)=-2*%pi*sin(2*%pi*x)*sin(2*%pi*y)';


sexacte='sin(2*%pi*x)*sin(2*%pi*y)*sin(2*%pi*z)';
