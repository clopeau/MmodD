// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in=assemble_pde_df2d(%in,opt)
  // separation de l'equation
  ind=strindex(%in.eq,'=')
  pmbr=part(%in.eq,1:ind-1);
  smbr=part(%in.eq,ind+1:length(%in.eq));
  
  // premier membre
  // matrice
  if find(opt==1)~=[]
    %in.A=[];
    %in.A=evstr(pmbr)
    for i=1:length(%in.BndId)
      ind=strindex(%in.BndVal(i),'=')
      ppmbr=part(%in.BndVal(i),1:ind-1);
      ppmbr=strsubst(ppmbr,'Dn('+%in.var+')','Dn('+%in.var+','''+%in.BndId(i)+''')')
      ppmbr=strsubst(ppmbr,'Id('+%in.var+')','Id('+%in.var+','''+%in.BndId(i)+''')')
      %in.A=%in.A+evstr(ppmbr);
    end
  end

  // second membre
  if find(opt==2)~=[]
    %in.b=[];
    b=evstr('df2d('+%in.geo+','''+smbr+''')');
    %in.b=b.Node
    clear b
    for i=1:length(%in.BndId)
      %in.b(evstr(%in.geo+'('''+%in.BndId(i)+''')'))=0
    end
    
    for i=1:length(%in.BndId)
      ind=strindex(%in.BndVal(i),'=')
      ssmbr=part(%in.BndVal(i),ind+1:length(%in.BndVal(i)));
      execstr('Gloc=grid2d('+%in.geo+','''+%in.BndId(i)+''')');
      bloc=evstr('df2d(Gloc,'''+string(ssmbr)+''')');
      ind=evstr(%in.geo+'('''+%in.BndId(i)+''')');
      %in.b(ind)=%in.b(ind)+bloc.Node
    end
  end
    
endfunction

