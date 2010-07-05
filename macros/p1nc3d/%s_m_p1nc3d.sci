function %in1=%s_m_p1nc3d(%s,%in1)
     [ns,ms]=size(%s);
     [n1s,m1s]=size(%in1.Face);
     if length(%s)==1
       // multiplication par un scalaire
       %in1.Face=%s* %in1.Face;
     elseif (ns==n1s)&(ms==m1s)
       // produit scalaire
       %in1.Face=sum(%s.* %in1.Face,'c');
     elseif (ms==1)&(ns==n1s)
       // une qantite scalaire par un vecteur
       %in1.Face=%s(:,ones(1:m1s)).* %in1.Face;
     elseif (ms==m1s)
       // Une matrice par un vecteur
       %in1.Face=%in1.Face*(%s');
     else
       error('inconsistent multiplication');
     end
     %in1.#=rand(1);
     
endfunction
