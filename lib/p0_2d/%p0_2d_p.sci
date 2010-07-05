function %p0_2d_p(var)
  write(%io(2),' Type '+typeof(var)+' Nom : '+string(var.Id));
  write(%io(2),'');
  write(%io(2),'      '+string(evstr('size('+var.geo+',''c'')'))+...
      'x'+string(size(var.Cell,2))+' inconnues');
endfunction
