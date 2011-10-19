mode(-1);
// u doit etre une variable definie

pb=pde(u);
pb.eq='-Laplace(u)=8*%pi^2*cos(2*%pi*x)*cos(2*%pi*y)';
pb.S='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
pb.N='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
pb.E='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';
pb.W='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)';

sexacte='cos(2*%pi*x)*cos(2*%pi*y)';
