// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=y_tet3d_Face(%th)
     n=size(%th.Tri,1);
     %out=sum(matrix(%th.Coor(%th.Tri,2),n,3),'c')/3;
endfunction
   
