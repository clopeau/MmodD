// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%p1_2d_p_p1_2d(%in2,%in1)
%in1.Node=%in2.Node .^ %in1.Node;
%in1.#=rand(1);
%in1.Id="("+%in2.Id+")^("+%in1.Id+")";
endfunction
  
