function %q1p2d_p(var)
  write(%io(2),' Type '+typeof(var)+' Nom : '+string(var.Id));
  write(%io(2),'');
  write(%io(2),'      '+string(evstr('size('+var.geo+')'))+...
      'x'+string(size(var.Node,2))+' inconnues');
endfunction
