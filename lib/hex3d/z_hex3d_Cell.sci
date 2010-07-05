function %out=z_hex3d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Hex,3),n,8),'c')/8;
endfunction
   
