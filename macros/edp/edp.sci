// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %pb = edp(%u)
    %nomvar=name(%u);
    %pb = mlist(['edp','#','Id','var','geo','eq','resol','A','b','flag',...
	    'BndId','TypBnd','BndVal'],...
	rand(),'',%nomvar,%u.geo,'','',[],[],[],list(),list(),list())
    for i=evstr(%u.geo+'.BndId')
      %pb(i)='Id('+%nomvar+')=0'
    end
    %pb.eq='-Laplace('+%nomvar+')=1';
endfunction
