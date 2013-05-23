// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  dcomp3d_vtk(u,%v)
// foncton d'export d'une dcomp3d
  [np,nf,nc]=size(%v);
  nif=zeros(1:nf)
  for i=1:nf
    nif(i)=length(%v.Face(i));
  end
  mfprintf(u,'DATASET POLYDATA\n');
  mfprintf(u,'POINTS %i float\n',np);
  mfprintf(u,'%3.12f %3.12f %3.12f\n',%v.Coor);
  mfprintf(u,'POLYGONS %i %i\n',nf,sum(nif)+nf);
  ii=' %i';
  for i=1:nf
    mfprintf(u,'%i'+strcat(ii(ones(1:nif(i))))+'\n',nif(i),%v.Face(i)-1)
  end
  
  mfprintf(u,'CELL_DATA %i\n',nf);
  mfprintf(u,'SCALARS id int 1\n');
  mfprintf(u,'LOOKUP_TABLE default\n');
  mfprintf(u,'%i\n',%v.Type')
endfunction

