// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=%p1_2d_e(varargin)
   [lhs,rhs]=argn(0);
    // v variable p1
    %v=varargin($);
    %out=p1_1d();
    %out.geo=%v.geo
    if rhs==2
      if type(varargin(1))==1
	%out.Node=%v.Node(varargin(1),:);
      else
	%th=evstr(%v.geo)
	%out.Node=%v.Node(evstr('%th(""'+varargin(1)+'"")'),:);
      end
    elseif rhs==3
      %out.Node=%v.Node(varargin(1),varargin(2));
    else
      error('Incorrect number of argument in %p1_e')
    end
endfunction
  
      
