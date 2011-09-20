// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function xedp(%in)

    rect=typeof(%in)

    if rect=='edp'
      
      listBnd=evstr(%in.geo+'.BndId');
      nbnd=size(listBnd,'*')
      txtBnd=string(1:nbnd);
      valBnd=txtBnd;
      for i=1:nbnd 
	txtBnd(i)=string(evstr(%in.geo+'.BndId(i)'))
	valBnd(i)=%in.BndVal(i)
      end
      
      txt=['   edp       :   '+name_mmodd(%in);
	   'geometrie    :   '+%in.geo+'   ('+evstr('typeof('+%in.geo+')')+')';
	   'variable     :   '+%in.var+'   ('+evstr('typeof('+%in.var+')')+')';
	   ' ']
	      
      sig=x_mdialog(txt,['Equation',txtBnd] ,[ %in.eq valBnd])
      if sig==[]
	return
      end
      
      %in.eq=sig(1)
      for i=1:nbnd
	execstr('%in('''+txtBnd(i)+''')=sig(i+1)');
      end
       
    end
    
    execstr('['+name_mmodd(%in)+']=return(%in);');
 endfunction
  
  
