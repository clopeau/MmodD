function %th=line2d(varargin)
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
	if size(varargin(1))~=2
	  error('Les points doivent avoir 2 coordonnées')
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
    
    
    %th=mlist(['line2d';'#';'Id';'Coor';'Seg';'BndPerio'],...
	rand(),Id,Coor,Seg,BndPerio)
    
endfunction
