function G=export_grid1d(G,In)
     G.#=rand();
     In=convstr(In,'u');
     if In=='O'
       In='W';
     end

     select In
     case 'W'
       G.x=G.x(1);
     case 'E'
       G.x=G.x($);
     end
     
endfunction
   
