function out = %df3d_e(varargin)
   [lhs,rhs]=argn(0);
 
   in=varargin($);
   G=evstr(in.geo)
   bnd=varargin(1);
   out=df3d(G);
   out.geo='grid3d('+in.geo+','''+bnd+''')'
   out.Node=in.Node(G(bnd))
endfunction