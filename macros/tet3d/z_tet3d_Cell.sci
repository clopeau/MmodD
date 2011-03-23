function %out=z_tet3d_Cell(%th)
     n=size(%th,'c')
     %out=sum(matrix(%th.Coor(%th.Tet,3),n,4),'c')/4;
endfunction
   
