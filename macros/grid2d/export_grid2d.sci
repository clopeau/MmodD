// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function G=export_grid2d(G,In)
     G.#=rand();
     In=convstr(In,'u');
     if In=='O'
       In='W';
     end

     select In
     case 'S'
       G.y=G.y(1);  
     case 'N'
       G.y=G.y($);  
     case 'W'
       G.x=G.x(1);
     case 'E'
       G.x=G.x($);
     end
     
endfunction
   
