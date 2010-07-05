function %p1nc3d_p(var)
  write(%io(2),' Type '+typeof(var)+' Nom : '+string(var.Id));
  write(%io(2),'');
  write(%io(2),'      '+string(evstr('size('+var.geo+'.Tri,1)'))+...
      'x'+string(size(var.Face,2))+' inconnues');
endfunction
