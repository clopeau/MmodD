function pb = edp(%u)
    nomvar=name(%u);
    pb = mlist(['edp','#','Id','var','geo','eq','resol','A','b','flag',...
	    'BndId','TypBnd','BndVal'],...
	rand(),'',nomvar,%u.geo,'','',[],[],[],list(),list(),list())
    for i=evstr(%u.geo+'.BndId')
      pb(i)='Id('+nomvar+')=0'
    end
endfunction
