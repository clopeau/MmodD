function A=Dy_p1_2d(%u)
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  //-------------- Assemblage -------------------------------------------------
  A=spzeros(nf,nf);

  for i=1:3
    // init fct de base i
    tmp=%th.Coor(%th.Tri(:,index(1,i)),1)-...
	%th.Coor(%th.Tri(:,index(2,i)),1);
    tmp=tmp/6;
 
    for j=1:3
      A=A+sparse(%th.Tri(:,[i,j]),tmp,[nf,nf]);
    end
  end

endfunction

