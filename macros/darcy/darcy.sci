function pb = darcy(%p,%v)
    nomp=name(%p);
    nomv=name(%v);
    pb = mlist(['darcy','#','Id','pression','vitesse','geo','eq','resol','A','b','f',...
	    'K','Dx','Dy','Dz','M','BndId','TypBnd','BndVal'],...
	rand(),'',nomp,nomv,%p.geo,'','',[],[],[],[],[],[],[],[],list(),list(),list())
    
    for i=evstr(%p.geo+'.BndId')
      pb(i)='Id('+nomp+')=0'
    end
    
endfunction
