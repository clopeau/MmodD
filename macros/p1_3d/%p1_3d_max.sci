// Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=%p1_3d_max(in,in2)
[lhs,rhs]=argn(0);
   if rhs==1
     out=max(in.Node,'r');
   else
     if typeof(in)=="p1_3d" & typeof(in2)=="p1_3d"
       out=in;
       out.Node=max(in.Node,in2.Node)
       out.Id="max("+in.Id+","+in2.Id+")";
     elseif  typeof(in)=="p1_3d" & type(in2)==1
       out=in;
       out.Node=max(in.Node,in2)
       out.Id="max("+in.Id+","+string(in2)+")";
     elseif  type(in)==1 & typeof(in2)=="p1_3d"
       out=in2;
       out.Node=max(in,in2.Node)
       out.Id="max("+string(in)+","+in2.Id+")";
     else
       error("Incompatible type in %p1_3d_maxi")
     end
     out.#=rand(1)
   end
   
endfunction
