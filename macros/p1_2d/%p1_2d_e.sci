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
	%out=p1_2d();
	%out.geo=varagin($).geo
	ierr=execstr('%out.Id=varagin($).Id(varargin(1))','errcatch');
	%out.Node=varagin($).Node(:,varargin(1));
      else
	%out=p1_1d();
	%out.geo=varagin($).geo
	%th=evstr(varagin($).geo)
	%out.Node=varagin($).Node(evstr('%th(""'+varargin(1)+'"")'),:);
      end
    elseif rhs==3
      %out=varagin($).Node(varargin(1),varargin(2));
    else
      error('Incorrect number of argument in %p1_2d_e')
    end
endfunction
  
      
