function Cell_gmv(u,%v)
  nomvar=strsubst(%v.Id,' ','')
  if nomvar==''
    nomvar=name(%v);
  end
  [a,ierr]=evstr(nomvar);
  if nomvar==''|ierr==0
    nomvar='scalaire';
  end
  nomvar=strsubst(nomvar,'%','')
  
  fprintf(u,nomvar+' 0');
  fprintf(u,"%f\n",%v.Cell);
endfunction
  