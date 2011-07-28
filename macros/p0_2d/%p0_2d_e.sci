
// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out = %p0_2d_e(varargin)
   [lhs,rhs]=argn(0);
    // %v variable p0
    %v=varargin($);
    if rhs==2
      if type(varargin(1))==1
	%out=p0_2d();
	%out.geo=%v.geo
	ierr=execstr('%out.Id=%v.Id(varargin(1))','errcatch');
	%out.Cell=%v.Cell(:,varargin(1));
      else
	error('Incorrect type of argument in %p0_2d_e')
      end
    elseif rhs==3
      %out=%v.Cell(varargin(1),varargin(2));
    else
      error('Incorrect number of argument in %p0_2d_e')
    end
          
endfunction
