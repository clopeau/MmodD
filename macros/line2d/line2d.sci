// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %th=line2d(%g,Bnd)
// Type declaration
// 
// Calling Sequence
// line2d(varargin)
// 
// Parameters
//  varargin : if string then it's the line2d 's identity and if matrix then it's line2d 's point coordinates 
//
// Description
// line2d returns an empty list if varagin is a string or a list that contains :
//    Id : identity
//    Coor : coordinates matrix 
//    Seg  : segment matrix 
//
// Examples
// a=line2d('name')
// a.Id
// b=line2d([1 1;2 2; 5 0;9 9])
// b.Id='my_line2d'
// b.Coor
// b.Seg
//
// See also
// line3d
//
// Authors
// Clopeau T., Delanoue D., Ndeffo M. and Smatti S.

   [lhs,rhs]=argn(0);
    %Id="";Coor=[];Seg=[];BndPerio=%f
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
	Seg=(1:size(Coor,1))';
	if and(Coor(1,:)==Coor($,:))
	  BndPerio=%t;
	  Seg($)=1
	end
      end
      //------------ Extraction d'une geometrie ---------
    elseif rhs==2
      ind=grep(%g.BndId,Bnd)
      Seg=%g.Bnd(ind)
      Coor=%g.Coor(Seg,:)
      Seg=(1:size(Coor,1))';
      if and(Coor(1,:)==Coor($,:))
	BndPerio=%t;
	Seg($)=1
      end
    end
    
    
    %th=mlist(['line2d';'#';'Id';'Coor';'Seg';'BndPerio'],...
	rand(),%Id,Coor,Seg,BndPerio)
    
endfunction
