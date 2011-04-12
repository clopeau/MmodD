// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=kLaplace_p1_2d(%kk,%u)
  if typeof(%kk)=='p1_2d'
      %kk=p0(%kk)
  end
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
  invdet=(-1/2).*%kk.Cell ./invdet ;
  clear tmp;
  //-------------- Assemblage -------------------------------------------------
  Tmp1=zeros(nt,2); // 1 ere fct de base
  Tmp2=zeros(nt,2); // 2 eme fcr de base
  // Tensor matrix
  A=spzeros(nf,nf);
  Diag=spzeros(nf,1);
  
  for i=1:3
    // init fct de base i
    Tmp1(:,1)=%th.Coor(%th.Tri(:,index(1,i)),2)-...
	%th.Coor(%th.Tri(:,index(2,i)),2);
    Tmp1(:,2)=%th.Coor(%th.Tri(:,index(2,i)),1)-...
	  %th.Coor(%th.Tri(:,index(1,i)),1); 
    // Assemblage termes diagonal
    tmp=sum(Tmp1.^2,'c') .*invdet;
    
    Diag=Diag+sparse([%th.Tri(:,i),ones(nt,1)],tmp,[nf,1]);
    //
    for j=i+1:3
      // init fonct de base j
      Tmp2(:,1)=%th.Coor(%th.Tri(:,index(1,j)),2)-...
	  %th.Coor(%th.Tri(:,index(2,j)),2);
      Tmp2(:,2)=%th.Coor(%th.Tri(:,index(2,j)),1)-...
	  %th.Coor(%th.Tri(:,index(1,j)),1);
      
      tmp=sum(Tmp1.*Tmp2,'c') .*invdet;
      
      A=A+sparse(%th.Tri(:,[i,j]),tmp,[nf,nf]);
    end
  end
  
  clear Tmp1 Tmp2;  
  A=A+A'+diag(Diag);

endfunction

