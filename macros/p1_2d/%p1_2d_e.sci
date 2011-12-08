// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=%p1_2d_e(varargin)
   [lhs,rhs]=argn(0);
    // v variable p1
    //%v=varargin($);
    
    if rhs==2
      if type(varargin(1))==1
	execstr('%out=p1_2d('+varargin($).geo+')');
	ierr=execstr('%out.Id=varargin($).Id(varargin(1))','errcatch');
	%out.Node=varargin($).Node(:,varargin(1));
      else
	%out=p1_1d();
	%out.geo=varargin($).geo
	%th=evstr(varargin($).geo)
	%out.Node=varargin($).Node(evstr(%out.geo+'(""'+varargin(1)+'"")'),:);
      end
    elseif rhs==3
      %out=varargin($).Node(varargin(1),varargin(2));
    else
      error('Incorrect number of argument in %p1_2d_e')
    end
endfunction
  
      
