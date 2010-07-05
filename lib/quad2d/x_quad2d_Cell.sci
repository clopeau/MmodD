function %out=x_quad2d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Quad,1),n,4),'c')/4;
endfunction
   
