// Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %th=edge2d(%g,Bnd)
  [lhs,rhs]=argn(0);
  %Id="";Coor=[];CoorId=[];Ed=[];EdId=[];
  if rhs==1
    select typeof(%g)
     case 'string'
      %Id=%g
     case 'constant'
      if size(%g)~=2
	error('Points must have two coordinates')
	return
      end
      Coor=%g
      Ed=[(1:size(Coor,1)-1)', (2:size(Coor,1))'];
    end  
	  
      //------------ Extraction d'une geometrie ---------
    elseif rhs==2
      
      ind=find(%g.BndId==Bnd)
      Ed=%g.Bnd(ind)
      ind=unique(Ed)
      Coor=%g.Coor(ind,:)
      CoorId=ind;
      tab=sparse([ind,ones(ind)],(1:length(ind))',[max(ind),1]);
      Ed=matrix(tab(Ed),-1,2)
    end
    
    
    %th=mlist(['edge2d';'#';'Id';'Coor';'CoorId';'Ed';'EdId'],...
	      rand(),%Id,Coor,CoorId,Ed,[])
    
endfunction
