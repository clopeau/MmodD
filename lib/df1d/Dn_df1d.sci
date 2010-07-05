function  A=Dn_df1d(u,Bnd);
  G=evstr(u.geo);
  In=convstr(Bnd,'u');
  if In=='O'
    In='W';
  end
  nx=size(G);
  select In
  case 'W'
    h=1/(G.x(2)-G.x(1));
    A=sparse([1 1;1 2],[h;-h],[nx,nx]);
  case 'E'
    h=1/(G.x($)-G.x($-1));
    A=sparse([nx,nx;nx,nx-1],[h;-h],[nx,nx]);
  end
endfunction
