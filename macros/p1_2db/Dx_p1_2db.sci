function A=Dx_p1_2db(%u)
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  //-------------- Assemblage -------------------------------------------------
  A=spzeros(nf+nt,nf+nt);

  for i=1:3
    // init fct de base i
    tmp=%th.Coor(%th.Tri(:,index(2,i)),2)-...
	%th.Coor(%th.Tri(:,index(1,i)),2);
    tmp=tmp/6;
 
    for j=1:3
      A=A+sparse(%th.Tri(:,[i,j]),tmp,[nf,nf]);
    end
  end

endfunction

