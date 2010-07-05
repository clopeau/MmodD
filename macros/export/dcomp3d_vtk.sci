function  dcomp3d_vtk(u,%v)
// foncton d'export d'une dcomp3d
  [np,nf,nc]=size(%v);
  nif=zeros(1:nf)
  for i=1:nf
    nif(i)=length(%v.Face(i));
  end
  fprintf(u,'DATASET POLYDATA\n');
  fprintf(u,'POINTS %i float\n',np);
  fprintf(u,'%3.12f %3.12f %3.12f\n',%v.Coor);
  fprintf(u,'POLYGONS %i %i\n',nf,sum(nif)+nf);
  ii=' %i';
  for i=1:nf
    fprintf(u,'%i'+strcat(ii(ones(1:nif(i))))+'\n',nif(i),%v.Face(i)-1)
  end
  
  fprintf(u,'CELL_DATA %i\n',nf);
  fprintf(u,'SCALARS id int 1');
  fprintf(u,'LOOKUP_TABLE default');
  fprintf(u,'%i\n',%v.Type')
  

