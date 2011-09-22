function %tri3d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type '+typeof(th)+' Name : '+string(th.Id));
  [np,nt]=size(th);
  write(%io(2),'        '+string(np)+' points');
  write(%io(2),'        '+string(nt)+' triangles');
  for i=1:length(th.Bnd)
    write(%io(2),'   '+string(th.BndId(i))+' : '+...
	string(length(th.Bnd(i)))+' points');
  end
endfunction

  
