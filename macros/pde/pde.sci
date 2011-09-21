// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %pb = pde(%u)
    %nomvar=name_mmodd(%u);
    %pb = mlist(['pde','#','Id','var','geo','eq','resol','A','b','flag',...
	    'BndId','TypBnd','BndVal'],...
	rand(),'',%nomvar,%u.geo,'','',[],[],[],list(),list(),list())
    for i=evstr(%u.geo+'.BndId')
      %pb(i)='Id('+%nomvar+')=0'
    end
    %pb.eq='-Laplace('+%nomvar+')=1';
endfunction
