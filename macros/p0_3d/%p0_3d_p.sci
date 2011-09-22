// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %p0_3d_p(var)
  write(%io(2),' Type '+typeof(var)+' Name : '+string(var.Id));
  write(%io(2),'');
  write(%io(2),'      '+string(evstr('size('+var.geo+',''c'')'))+...
      'x'+string(size(var.Cell,2))+' inconnues');
endfunction
