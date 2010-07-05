function [out]=getNodeNC(i,j,k,G)
  // Pour i,j,k donne (indexation tensorisée des faces du  cube)
  // Renvoie les numeros des faces correspondant
  // code 1 : face avant, 2 face arriere , 3 inexistant

  [nx,ny,nz]=size(G,"Node");
  if i<3
    out=zeros((nx-1),(ny-1)*(nz-1));
    out(:,:)=(ny-1)*(nz-1);
    out(1,:)=(1+(i-1)*(ny-1)*(nz-1)):i*(ny-1)*(nz-1);
    out=matrix(cumsum(out,"r"),-1,1);
 
  elseif j<3
    tmp=zeros(ny-1,nz-1);
    tmp(:,:)=(nx-1)*(nz-1);
    tmp(1,:)=(1+(j-1)*(nx-1)*(nz-1)):(nx-1):((nz-2)*(nx-1)+(j-1)*(nx-1)*(nz-1)+1);
    tmp=matrix(cumsum(tmp,"r"),1,-1);
    out=ones(nx-1,(ny-1)*(nz-1));
    out(1,:)=tmp;
    out=matrix(cumsum(out,"r"),-1,1);
    out=out+(nx*(ny-1)*(nz-1));
  elseif k<3
     out=(1+(k-1)*(nx-1)*(ny-1):(nz+k-2)*(nx-1)*(ny-1));
     out=out';
     out=out+(nx*(ny-1)*(nz-1))+(nx-1)*ny*(nz-1);
  end
endfunction


