function out = %p1nc3d_e(varargin)
   [lhs,rhs]=argn(0);
   
   in=varargin($);
   
   // Extraction avec 1 parmetre
   //  cas "par composante vectorielle"
   if rhs==2 & type(varargin(1))~=10
     //G=evstr(in.geo)
     out=in.Face(:,varargin(1))
   // cas "par frontiere"  
   elseif rhs==2 & type(varargin(1))==10
     G=evstr(in.geo)
     id=find(G.BndId==varargin(1))
       if id==[] 
	 error('Bad Boundary Name argument');  
       end
     out=in.Face(G.BndiTri(id),:)
   // cas "par composante vectorielle  et frontière"
   elseif rhs==3
     G=evstr(in.geo)
     out=in.Face(G(varargin(2)),varargin(1))
   else
     error('Extraction non-admise')
   end   
          
endfunction
