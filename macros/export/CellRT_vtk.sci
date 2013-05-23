// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function CellRT_vtk(u,%v)
//  fprintf(u,'POINT_DATA '+string(size(%v)));

  nomvar=strsubst(%v.Id,' ','')
  if nomvar==''
    nomvar=name_mmodd(%v);
  end
  [a,ierr]=evstr(nomvar);
  if nomvar==''|ierr==0
    nomvar='scalaire';
  end
  nomvar=strsubst(nomvar,'%','')

  mfprintf(u,'SCALARS '+nomvar+' float 1\n');
  mfprintf(u,"LOOKUP_TABLE default");
  // var locales
  Base= [1 2 3 3 3 3;
	 3 3 1 2 3 3;
	 3 3 3 3 1 2]; 
     
  // info sur grille
  G=evstr(%v.geo);
  [nx,ny,nz]=size(G);
  ntot=size(G,"Face");
  ncel=size(G,"Cell");
  
  // initialisation 
  // Nombre de cellules
  Mat=spzeros(ncel,ntot);
    
  for ii=1:6
    Mat=Mat+sparse([(1:ncel)',G(Base(:,ii),'c2f')],1/6*ones(ncel,1),[ncel,ntot]);
  end    
  
  mfprintf(u,"%f\n ",Mat*%v.Face);
endfunction
  
