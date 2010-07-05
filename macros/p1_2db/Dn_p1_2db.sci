function A=Dn_p1_2db(u,Bnd);

     G=evstr(u.geo);
     [n,t]=size(G)
     A=spzeros(n+t,n+t)
     
 endfunction
