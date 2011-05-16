function %out=y_tri3d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Tri,2),n,3),'c')/3;
endfunction
   
