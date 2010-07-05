function %out=y_line3d_Cell(%th)
     n=size(%th,'c');
     tmp=%th.Coor(%th.Seg,2)
     %out=(tmp(1:$-1)+tmp(2:$))/2;
endfunction
   
