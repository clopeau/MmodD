// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %edge2d_p(th)
// Fonction d'affichage
// a revoir
  write(%io(2),'Type edge2d Name : '+string(th.Id));
  [np,ne]=size(th);
  write(%io(2),'        '+string(np)+' points');
  write(%io(2),'        '+string(ne)+' edges');
endfunction

  
