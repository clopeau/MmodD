function out = %df2d_e(varargin)
   [lhs,rhs]=argn(0);
   
   in=varargin($);
   G=evstr(in.geo)
   bnd=varargin(1);
   out=df2d(G);
   out.geo='grid2d('+in.geo+','''+bnd+''')'
   out.Node=in.Node(G(bnd))
 endfunction
 