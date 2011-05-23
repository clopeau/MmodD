function out = %p0_1d_e(varargin)
   [lhs,rhs]=argn(0);
   
   in=varargin($);
   
   // Extraction avec 1 parmetre
   //  cas "par composante vectorielle"
   if rhs==2 & type(varargin(1))~=10
     G=evstr(in.geo)
     out=in.Cell(:,varargin(1))
   // cas "par frontiere"  
   elseif rhs==2 & type(varargin(1))==10
     G=evstr(in.geo)
     out=in.Cell(G(varargin(1)),:)
   // cas "par composante vectorielle  et frontière"
   elseif rhs==3
     G=evstr(in.geo)
     out=in.Cell(G(varargin(2)),varargin(1))
   else
     error('Extraction non-admise')
   end   
          
endfunction
