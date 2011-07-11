// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_2d_l_s(%in1,%s)
%in1.Node= %in2.Node .\ %s;
%in1.#=rand(1);
%in1.Id=ldivf(%in1.Id,string(%s));
endfunction
   
