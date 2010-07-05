function %hex3d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type '+typeof(th)+' Nom : '+string(th.Id));
  [np,nt]=size(th);
  write(%io(2),'        '+string(np)+' points');
  write(%io(2),'        '+string(nt)+' hexaedres');
endfunction

  
