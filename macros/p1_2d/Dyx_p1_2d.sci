// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=Dyx_p1_2d(%u)
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  index=[2 3; 3 1; 1 2]';
  //------------- Calcul du déterminant ---------------------------------------
  invdet=zeros(nt,1);
  tmp=zeros(nt,1);
  for i=1:3
      tmp=%th.Coor(%th.Tri(:,index(1,i)),2)- %th.Coor(%th.Tri(:,index(2,i)),2);
      invdet=invdet+%th.Coor(%th.Tri(:,i),1).*tmp;
    end
  invdet=(-1/2) ./invdet;
  clear tmp;
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,1); // 1 ere fct de base
  Tmp2=zeros(nt,1); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  
  for i=1:3
    // init fct de base i
    Tmp1 =%th.Coor(%th.Tri(:,index(2,i)),1)-...
	  %th.Coor(%th.Tri(:,index(1,i)),1); 
    //
    for j=1:3
      // init fonct de base j
      Tmp2=%th.Coor(%th.Tri(:,index(1,j)),2)-...
	  %th.Coor(%th.Tri(:,index(2,j)),2);
       
      tmp=Tmp1.*Tmp2 .*invdet;
      
      A=A+sparse(%th.Tri(:,[i,j]),tmp,[nf,nf]);
    end
  end
  
  
endfunction

