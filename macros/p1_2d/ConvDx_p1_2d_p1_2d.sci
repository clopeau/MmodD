// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function A=ConvDx_p1_2d_p1_2d(%u,%c)
  [lhs,rhs]=argn(0);
  %th=evstr(%u.geo);
  [nf,nt]=size(%th);
  
  if typeof(%c)=='p1_2d'
    %c=p0(%c);
  end
  
  index=[2 3; 3 1; 1 2]';
  //-------------- Assemblage -------------------------------------------------
  A=spzeros(nf,nf);
  ci=1/(24); // terme extra diag de la matrice de masse
  cid=1/(12); // term diag
  
  for k=1
    for j=1:3
      // init fct de base i
      tmp=(-1)^k *( %th.Coor(%th.Tri(:,index(2,j)),3-k)-...
	  %th.Coor(%th.Tri(:,index(1,j)),3-k));
      for i=1:3
	tmp2=zeros(tmp);
	for l=1:3
	  if l==j
	    cc=cid;
	  else
	    cc=ci
	  end
	  tmp2=tmp2+cc*%u.Node(%th.Tri(:,l),k)
	end
	A=A+sparse(%th.Tri(:,[i,j]),tmp.*tmp2,[nf,nf]);
      end
    end
  end
  
endfunction
