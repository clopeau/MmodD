function %p1_2db_p(var)
  write(%io(2),' Type '+typeof(var)+' Nom : '+string(var.Id));
  write(%io(2),'');
  execstr('[n,t]=size('+var.geo+')');
  s=n+t;
  write(%io(2),'      '+string(s)+...
      'x'+string(size(var.Node,2))+' inconnues');
endfunction
