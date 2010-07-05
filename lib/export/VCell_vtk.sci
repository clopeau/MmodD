function VCell_vtk(u,%v)
  [n,dim]=size(%v)
  if typeof(%v)=='p1nc3d'
    %v=p0(%v)
  end
  ttype=typeof(%v);
  
  //---- Traitement du nom de la variable -----
  nomvar=strsubst(%v.Id(1),' ','')
  if nomvar==''
    nomvar=name(%v);
  end
  [a,ierr]=evstr(nomvar);
  if nomvar==''|ierr==0
    nomvar='Cvect'+part(string(rand(1)*1000000),1:3);
  end
  nomvar=strsubst(nomvar,'%','')
  fprintf(u,'VECTORS '+nomvar+' float');
  
   //--- ecriture suivant taille ------
  Var2dCell=['p0_2d']
  if grep(Var2dCell,ttype)~=[]&(dim==2)
    fprintf(u,"%g %g 0.\n ",%v.Cell);
    pause
  end
  
  Var3dCell=['p0_3d' 'p0_2d']
  if grep(Var3dCell,ttype)~=[]&(dim==3)
    fprintf(u,"%g %g %g\n ",%v.Cell);
  end

endfunction
  
