function out = %p0_1d_e(varargin)
   [lhs,rhs]=argn(0);
   
   //in=varargin($);
   
   // Extraction avec 1 parmetre
   //  cas "par composante vectorielle"
   if rhs==2 & type(varargin(1))~=10
     G=evstr(varargin($).geo)
     out=varargin($).Cell(:,varargin(1))
   // cas "par frontiere"  
   elseif rhs==2 & type(varargin(1))==10
     G=evstr(varargin($).geo)
     out=varargin($).Cell(G(varargin(1)),:)
   // cas "par composante vectorielle  et fronti�re"
   elseif rhs==3
     G=evstr(varargin($).geo)
     out=varargin($).Cell(G(varargin(2)),varargin(1))
   else
     error('Extraction non-admise')
   end   
          
endfunction
