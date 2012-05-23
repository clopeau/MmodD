// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in=assemble_pde_p1_2d(%in,opt)
  %Penal=1e10
  // separation de l'equation
  ind=strindex(%in.eq,'=')
  pmbr=part(%in.eq,1:ind-1);
  smbr=part(%in.eq,ind+1:length(%in.eq));
 
  // premier membre
  // matrice
  if find(opt==1)~=[]
    %in.A=[];
    execstr('%in.A='+pmbr)
    for i=1:size(%in.BndId,'*')
      ind=strindex(%in.BndVal(i),'=')
      ppmbr=part(%in.BndVal(i),1:ind-1);
      if grep(ppmbr,'Dn('+%in.var+')')~=[]
	ppmbr=strsubst(ppmbr,'Dn('+%in.var+')',...
	    'Dn('+%in.var+','''+%in.BndId(i)+''')');
      else
	ppmbr=string(%Penal)+'*('+ppmbr+')';
      end
      ppmbr=strsubst(ppmbr,'Id('+%in.var+')','Id('+%in.var+','''+%in.BndId(i)+''')')
      execstr('%in.A=%in.A+'+ppmbr);
    end
  end

  // second membre
  if find(opt==2)~=[]
    %in.b=[];
    %domain= evstr(%in.var+'.domain')
    if  %domain==[]
      execstr('b=p1_2d('+%in.geo+','''+smbr+''')');
    else
      execstr('b=p1_2d('+%in.geo+','''+smbr+''',domain=%domain)');
    end
    execstr('%in.b=Id('+%in.var+')*b.Node');
    clear b
    //for i=1:length(%in.BndId)
    //  %in.b(evstr(%in.geo+'('''+%in.BndId(i)+''')'))=0
    //end
    if %domain~=[]
      %tmp=evstr('cumsum('+%in.var+'.BoolNode)');
      execstr('%tmp(~'+%in.var+'.BoolNode)=0');
    end
    
    for i=1:size(%in.BndId,'*')
      ind=strindex(%in.BndVal(i),'=')
      ssmbr=part(%in.BndVal(i),ind+1:length(%in.BndVal(i)));
      ppmbr=part(%in.BndVal(i),1:ind-1);
      execstr('Gloc=line2d('+%in.geo+','''+%in.BndId(i)+''')');
      execstr('bloc=p1_1d(Gloc,'''+string(ssmbr)+''')');
      if grep(ppmbr,'Dn('+%in.var+')')~=[]
         %PP=1;
      else
	%PP=%Penal;
      end
      execstr('ind='+%in.geo+'.Bnd(i)');
      if  %domain~=[]
	ind=%tmp(ind);
	if min(ind)>0
	  execstr('M=Id_p1_2d('+%in.var+','''+%in.BndId(i)+''')');
	  %in.b(ind)=%in.b(ind)+%PP*M(ind,ind)*bloc.Node
	end
      else
	execstr('M=Id_p1_2d('+%in.var+','''+%in.BndId(i)+''')');
	%in.b(ind)=%in.b(ind)+%PP*M(ind,ind)*bloc.Node
      end
    end
  end
    
endfunction

