function %in1=%s_m_p0_1d(%s,%in1)
     [ns,ms]=size(%s);
     [n1s,m1s]=size(%in1.Cell);
     if length(%s)==1
       // multiplication par un scalaire
       %in1.Cell=%s* %in1.Cell;
     elseif (ns==n1s)&(ms==m1s)
       // produit scalaire
       %in1.Cell=sum(%s.* %in1.Cell,'c');
     elseif (ms==1)&(ns==n1s)
       // une qantite scalaire par un vecteur
       %in1.Cell=%s(:,ones(1:m1s)).* %in1.Cell;
     elseif (ms==m1s)
       // Une matrice par un vecteur
       %in1.Cell=%in1.Cell*(%s');
     else
       error('inconsistent multiplication');
     end
     %in1.#=rand(1);
     
endfunction
