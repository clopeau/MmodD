function  %darcy_p(%u)
  write(%io(2),' Type '+typeof(%u)+' Nom : '+string(%u.Id));
  write(%io(2),'');
  write(%io(2),' Geometry  :   '+%u.geo);
  write(%io(2),' Pression  :   '+%u.pression);
  write(%io(2),' Vitesse   :   '+%u.vitesse);
  write(%io(2),' K         :   ');
  write(%io(2),%u.K,'(''               | '',3(f10.3,'' | ''))');
  write(%io(2),' Force     :');
  write(%io(2),'               | '+%u.f)
  write(%io(2),' Boundary  :');

  for i=1:length(%u.BndId)
    write(%io(2),'             '+%u.BndId(i)+' -> '+...
	%u.TypBnd(i)+' '+string(%u.BndVal(i)));
  end
  
endfunction
  