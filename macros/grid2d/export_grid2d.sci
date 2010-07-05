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
   
