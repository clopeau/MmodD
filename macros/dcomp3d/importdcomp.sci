function th=importdcomp(nomfich)
  u=file('open',nomfich,'unknown')
  th=dcomp3d(nomfich)
  n=read(u,1,1)
  // Coordonnees
  th.Coor=read(u,n,3);
  // faces
  nf=read(u,1,1)
  th.Type=zeros(1:nf)
  for i=1:nf
    n=read(u,1,1)
    tmp=read(u,1,n+1);
    th.Face(i)=tmp(1:n)
    th.Type(i)=tmp($)
  end
  
  np=read(u,1,1);
  th.Mat=zeros(np,1)
  for i=1:np
    n=read(u,1,1)
    tmp=read(u,1,n+1);
    th.Cell(i)=tmp(1:n)
    th.Mat(i)=tmp($)
  end

  file('close',u);


