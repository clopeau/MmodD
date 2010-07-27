// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %line3d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type '+typeof(th)+' Nom : '+string(th.Id));
  [np,nt]=size(th);
  write(%io(2),'        '+string(np)+' points');
  write(%io(2),'        '+string(nt)+' segments');
endfunction

  
