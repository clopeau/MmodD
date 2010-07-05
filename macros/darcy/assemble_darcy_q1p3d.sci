function %in=assemble_darcy_q1p3d(%in,opt)
  %Penal=1e16
  DD=['Dx','Dy','Dz'];  
  // separation de l'equation
  pmbr='div_grad_q1p3d('+%in.pression+',%in.K)';

  // premier membre
  // matrice
  if find(opt==1)~=[]
    %in.A=[];
    %in.A=evstr(pmbr)
     for i=1:length(%in.BndId)
      ind=strindex(%in.BndVal(i),'=')
      ppmbr=part(%in.BndVal(i),1:ind-1);
      if grep(ppmbr,'Dn('+%in.vitesse+')')~=[]
	ppmbr=strsubst(ppmbr,'Dn('+%in.vitesse+')',...
	    'Dn('+%in.pression+','''+%in.BndId(i)+''')');
      else
	ppmbr=string(%Penal)+'*('+ppmbr+')';
      end
 	ppmbr=strsubst(ppmbr,'Id('+%in.pression+')',...
	    'Id('+%in.pression+','''+%in.BndId(i)+''')')
	%in.A=%in.A+evstr(ppmbr);
      end
     end

     // second membre
  if find(opt==2)~=[]
    %in.b=[];  
    NomFrontier=['W' 'E' 'S' 'N' 'D' 'U']
    Valf=list()
    for i=1:3
      b=evstr('q1p3d('+%in.geo+','''+%in.f(i)+''')');
      %in.b=%in.b+evstr(DD(i)+'(b)*b.Node');
      Valf(2*(i-1)+1)=-b(NomFrontier(2*(i-1)+1));
      Valf(2*(i-1)+2)=b(NomFrontier(2*(i-1)+2));
    end
    clear b
    for i=1:length(%in.BndId)
      ind=strindex(%in.BndVal(i),'=')
      ssmbr=part(%in.BndVal(i),ind+1:length(%in.BndVal(i)));
      ppmbr=part(%in.BndVal(i),1:ind-1);
 
      if grep(ppmbr,'Dn('+%in.vitesse+')')~=[] 
	%PP=1;
	ssmbr=ssmbr+'+Valf(find(NomFrontier==%in.BndId(i)))';
      else
	%PP=-%Penal;
      end
      
      execstr('Gloc=grid3d('+%in.geo+','''+%in.BndId(i)+''')');
      bloc=evstr('q1p3d(Gloc,'''+string(ssmbr)+''')');
      ind=evstr(%in.geo+'('''+%in.BndId(i)+''')');
      M=evstr('Id_q1p3d('+%in.pression+','''+%in.BndId(i)+''')');
      %in.b(ind)=%in.b(ind)-%PP*M(ind,ind)*bloc.Node     
    end
  end
endfunction

