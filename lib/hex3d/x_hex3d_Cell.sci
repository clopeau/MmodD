function %out=x_hex3d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Hex,1),n,8),'c')/8;
endfunction
   
