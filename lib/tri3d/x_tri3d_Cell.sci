function %out=x_tri3d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Tri,1),n,3),'c')/3;
endfunction
   
