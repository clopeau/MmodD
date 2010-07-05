function %out=y_hex3d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Hex,2),n,8),'c')/8;
endfunction
   
