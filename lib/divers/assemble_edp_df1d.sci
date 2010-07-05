function %in=assemble_edp_df1d(%in,opt)
  [rhs,lhs]=argn(0);
  if rhs==1
    opt=1:2
  end
  //nom_edp=name(%in);
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
    b=evstr('df1d('+%in.geo+','''+smbr+''')');
    %in.b=b.Node
    clear b
    for i=1:length(%in.BndId)
      %in.b(evstr(%in.geo+'('''+%in.BndId(i)+''')'))=0
    end
    
    for i=1:length(%in.BndId)
      ind=strindex(%in.BndVal(i),'=')
      ssmbr=part(%in.BndVal(i),ind+1:length(%in.BndVal(i)));
      ind=evstr(%in.geo+'('''+%in.BndId(i)+''')');
      execstr('x='+%in.geo+'.x('+%in.geo+'('''+%in.BndId(i)+'''))');
      bloc=evstr(string(ssmbr));
      
      %in.b(ind)=%in.b(ind)+bloc
    end
  end
  //execstr('['+nom_edp+']=return(%in);'); 
endfunction

