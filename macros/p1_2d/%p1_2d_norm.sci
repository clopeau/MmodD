// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=%p1_2d_norm(%in,%opt)
  [lhs,rhs]=argn(0);
  %th=evstr(%in.geo);
  [np,nt]=size(%th);
  if rhs==1 
    %opt=2
  else
    %bopt=%f
  end
  
  out=0;
  
  if %opt==2 | %opt=="L2" | %opt=="l2" | %opt=="H1" | %opt=="h1"
    out=sqrt(abs(sum(diag(%in.Node'*Id(%in)*%in.Node))));
    %bopt=%t
  end
  
  if %opt==1 | %opt=="L1" | %opt="l1"
    tmp=zeros(nt,size(%in.Node,2))
    for i=1:3
      tmp=tmp+%in.Node(%th.Tri(:,i),:);
    end
    out=sum(abs(tmp).*%th.Det(:,ones(1,size(%in.Node,2))))/6;
    %bopt=%t
  end
  
  if %opt==%inf | %opt=="Linf" | %opt="inf"
    out=max(abs(%in.Node));
    %bopt=%t
  end
    
  
  if  %opt=="H1" | %opt="h1" | %opt="semi-H1" | %opt="semi-h1" | ...
	   %opt=="semi_H1" | %opt="semi_h1"
    tmp=sum(diag(%in.Node'*(-Laplace(%in))*%in.Node))
    out=sqrt(out^2 + abs(tmp));
    %bopt=%t
  end
  
  if ~%bopt
    error('p1_2d norms available are 1 (L1), 2 (L2), inf (Linf),"+...
	  " H1, semi-H1")
  end
  
  
endfunction
