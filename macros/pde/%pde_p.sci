// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function  %pde_p(%u)
  write(%io(2),' Type '+typeof(%u)+' Id : '+string(%u.Id));
  write(%io(2),'');
  write(%io(2),' Geometry  :   '+%u.geo+'   ('+evstr('typeof('+%u.geo+')')+')');
  write(%io(2),' Variable  :   '+%u.var+'   ('+evstr('typeof('+%u.var+')')+')');
  write(%io(2),' Equation  :   '+%u.eq);
  write(%io(2),' Boundary  :');
  for i=1:size(%u.BndId,'*')
    write(%io(2),'             '+%u.BndId(i)+' -> '+...
	+string(%u.BndVal(i)));
  end
  
endfunction
