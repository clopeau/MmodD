mode(-1);
// u doit etre une variable definie

pb=pde(u);
pb.eq='-Laplace(u)=12*%pi^2*cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
pb.S='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'
pb.N='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'
pb.W='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'
pb.E='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'
pb.U='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'
pb.D='Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'

sexacte='cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)';
