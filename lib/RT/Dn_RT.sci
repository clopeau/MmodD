function A=Dn_RT(u,Bnd);
     G=evstr(u.geo);
     n=size(G,"F");
     A=spzeros(n,n);
 endfunction
