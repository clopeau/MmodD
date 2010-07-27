// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %th=line3d(varargin)
// Type declaration
// 
// Calling Sequence
// line3d(varargin)
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
// b=line2d([1 1 8;2 2 6; 5 0 0;9 9 18])
// b.Id='my_line3d'
// b.Coor
// b.Seg
//
// See also
// line2d
//
// Authors
// Clopeau T., Delanoue D., Ndeffo M. and Smatti S.

// declaration de type
//-----------------------------------------------------------
// type mesh
//----------
//    id : identite
//    Coor : tableau des coordonnees 
//    Seg  : tableau des indices des segments (liste chainee) 
    [lhs,rhs]=argn(0);
    Id="";Coor=[];Seg=[];BndPerio=%f
    if rhs==1
      select typeof(varargin(1))
      case 'string'
	Id=varargin(1)
      case 'constant'
	if size(varargin(1))~=3
	  error('Les points doivent avoir 3 coordonnées')
	  return
	end
	Coor=varargin(1)
	Seg=(1:size(Coor,1))';
	if and(Coor(1,:)==Coor($,:))
	  BndPerio=%t;
	  Seg($)=1
	end
      end
      //------------ Extraction d'une geometrie ---------
    elseif rhs==2
      Seg=varargin(1)(varargin(2))
      Coor=varargin(1).Coor(Seg,:)
      Seg=(1:size(Coor,1))';
      if and(Coor(1,:)==Coor($,:))
	BndPerio=%t;
	Seg($)=1
      end
    end
    
    
    %th=mlist(['line3d';'#';'Id';'Coor';'Seg';'BndPerio'],...
	rand(),Id,Coor,Seg,BndPerio)
    
endfunction
