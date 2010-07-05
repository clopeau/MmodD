function out = %df1d_e(varargin)
   [lhs,rhs]=argn(0);
   
   in=varargin($);
   G=evstr(in.geo)
   bnd=varargin(1);
   //out=df1d(G);
   out.geo='grid1d('+in.geo+','''+bnd+''')'
   out=in.Node(G(bnd));
 endfunction
 
