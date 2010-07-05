function A=Dn_df3d(u,Bnd);

     G=evstr(u.geo);
     In=convstr(Bnd,'u');
     if In=='O'
       In='W';
     end
     ind=G(Bnd);
     [nx,ny,nz]=size(G)
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
     case 'D' 
       h=1/(G.z(2)-G.z(1));
       ind1=ind+nx*ny;
     case 'U' 
       h=1/(G.z($)-G.z($-1));
       ind1=ind-nx*ny;
     end
     ind=ind(2:$-1);
     ind1=ind1(2:$-1);
     n=nx*ny*nz;
     A=sparse([ind,ind;ind,ind1],[h(ones(ind));-h(ones(ind))],[n,n])
     
 endfunction
