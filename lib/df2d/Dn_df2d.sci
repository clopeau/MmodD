function  A=Dn_df2d(u,Bnd);

     G=evstr(u.geo);
     In=convstr(Bnd,'u');
     if In=='O'
       In='W';
     end
     ind=G(Bnd);
     [nx,ny]=size(G)
     select Bnd
     case 'S'
       h=1/(G.y(2)-G.y(1));
       ind1=ind+nx;
     case 'N'
       h=1/(G.y($)-G.y($-1));
       ind1=ind-nx;
     case 'W'
       h=1/(G.x(2)-G.x(1));
       ind1=ind+1;
     case 'E'
       h=1/(G.x($)-G.x($-1));
       ind1=ind-1;
     end
     ind=ind(2:$-1);
     ind1=ind1(2:$-1);
     A=sparse([ind,ind;ind,ind1],[h(ones(ind));-h(ones(ind))],[nx*ny,nx*ny])
     
 endfunction
