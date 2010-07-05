function %out=y_quad2d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Quad,2),n,4),'c')/4;
endfunction
   
