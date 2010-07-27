// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=y_line2d_Cell(%th)
     n=size(%th,'c');
     tmp=%th.Coor(%th.Seg,2)
     %out=(tmp(1:$-1)+tmp(2:$))/2;
endfunction
   
