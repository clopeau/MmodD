function %dcomp3d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type '+typeof(th)+' Nom : '+string(th.Id));
  [np,nf,npy]=size(th);
  write(%io(2),'        '+string(np)+' points');
  write(%io(2),'        '+string(nf)+' faces');
  write(%io(2),'        '+string(npy)+' cellules');
endfunction

  
