function Node_vtk(u,%v)
//  fprintf(u,'POINT_DATA '+string(size(%v)));

  nomvar=strsubst(%v.Id,' ','')
  if nomvar==''
    nomvar=name(%v);
  end
  [a,ierr]=evstr(nomvar);
  if nomvar==''|ierr==0
    nomvar='scal'+part(string(rand(1)*1000000),1:3);
  end
  nomvar=strsubst(nomvar,'%','')

  fprintf(u,'SCALARS '+nomvar+' float 1\n');
  fprintf(u,"LOOKUP_TABLE default\n")
  fprintf(u,"g\n ",%v.Node);
endfunction
  
