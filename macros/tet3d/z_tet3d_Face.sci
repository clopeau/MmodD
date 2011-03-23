function %out=z_tet3d_Face(%th)
     n=size(%th.Tri,1);
     %out=sum(matrix(%th.Coor(%th.Tri,3),n,3),'c')/3;
endfunction
   
