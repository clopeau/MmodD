function xdarcy(%in)
    rect=typeof(%in)

      listBnd=evstr(%in.geo+'.BndId');
      nbnd=length(listBnd)
      txtBnd=string(1:nbnd);
      valBnd=txtBnd;
      for i=1:nbnd 
	txtBnd(i)=string(evstr(%in.geo+'.BndId(i)'))
	valBnd(i)=%in.BndVal(i)
      end
      
      txt=['  darcy      :   '+name(%in);
	   'geometrie    :   '+%in.geo+'   ('+evstr('typeof('+%in.geo+')')+')';
	   'variable     :   '+%in.var+'   ('+evstr('typeof('+%in.var+')')+')';
	   ' ']
      sig1=x_mdialog(txt,['Equation',txtBnd],[%in.eq valBnd])    
      
      
      %in.eq=sig1(1)
      for i=1:nbnd
	execstr('%in('''+txtBnd(i)+''')=sig1(i+1)');
      end 
      
      if rect=='darcy'
	//Traitons le cas du tenseur des perméabilités K pour Darcy
	if %in.K~=[]
	  [n,m]=size(%in.K);
	  row='row';
	  labelv=row(ones(1,n))+string(1:n);
	  col='col';labelh=col(ones(1,m))+string(1:m);
	  sig2=x_mdialog('K',labelv,labelh,string(%in.K));
	  K=evstr(sig2);
	  %in.K=K;
	end
      end
      
    execstr('['+name(%in)+']=return(%in);');
 endfunction
  
  
