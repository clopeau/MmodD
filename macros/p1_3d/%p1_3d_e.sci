// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %out=%p1_3d_e(varargin)
   [lhs,rhs]=argn(0);
   //%v=varargin($);
   if rhs==2
     if type(varargin(1))==1
       %out=p1_3d();
       %out.geo=varargin($).geo
       ierr=execstr('%out.Id=varargin($).Id(varargin(1))','errcatch');
       %out.Node=varargin($).Node(:,varargin(1));
     else
       %th=evstr(varargin($).geo)
       %out=varargin($).Node(unique(evstr('%th(""'+varargin(1)+'"")')),:);
      end
    elseif rhs==3
      %out=varargin($).Node(varargin(1),varargin(2));
    else
      error('Incorrect number of argument in %p1_3d_e')
    end
endfunction
  
      
