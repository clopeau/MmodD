// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %p1_2d_p(var)
  write(%io(2),' Type '+typeof(var)+', Id : '+string(var.Id));
  write(%io(2),'');
  if length(var.geo)>0
    write(%io(2),'      '+string(evstr('size('+var.geo+')'))+...
	'x'+string(size(var.Node,2))+' unknown');
  else
     write(%io(2),'      '+string(size(var.Node,1))+...
	'x'+string(size(var.Node,2))+' unknown');
  end
endfunction
