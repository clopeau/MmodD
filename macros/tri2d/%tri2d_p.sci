// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %tri2d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type '+typeof(th)+' Name : '+string(th.Id));
  [np,nt]=size(th);
  write(%io(2),'        '+string(np)+' points');
  write(%io(2),'        '+string(nt)+' triangles');
endfunction

  
