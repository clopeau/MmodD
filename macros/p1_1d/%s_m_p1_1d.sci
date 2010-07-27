// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %in1=%s_m_p1_1d(%s,%in1)
     [ns,ms]=size(%s);
     [n1s,m1s]=size(%in1.Node);
     if length(%s)==1
       // multiplication par un scalaire
       %in1.Node=%s* %in1.Node;
     elseif (ns==n1s)&(ms==m1s)
       // produit scalaire
       %in1.Node=sum(%s.* %in1.Node,'c');
     elseif (ms==1)&(ns==n1s)
       // une qantite scalaire par un vecteur
       %in1.Node=%s(:,ones(1:m1s)).* %in1.Node;
     elseif (ms==m1s)
       // Une matrice par un vecteur
       %in1.Node=%in1.Node*(%s');
     else
       error('inconsistent multiplication');
     end
     %in1.#=rand(1);
     
endfunction
