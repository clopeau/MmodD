// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=%p1_3d_mini(in,in2)
   [lhs,rhs]=argn(0);
   if rhs==1
     out=min(in.Node,'r');
   else
     if typeof(in)=="p1_3d" & typeof(in2)=="p1_3d"
       out=in;
       out.Node=min(in.Node,in2.Node)
       out.Id="min("+in.Id+","+in2.Id+")";
     elseif  typeof(in)=="p1_3d" & type(in2)==1
       out=in;
       out.Node=min(in.Node,in2)
       out.Id="min("+in.Id+","+string(in2)+")";
     elseif  type(in)==1 & typeof(in2)=="p1_3d"
       out=in2;
       out.Node=min(in,in2.Node)
       out.Id="min("+string(in)+","+in2.Id+")";
     else
       error("Incompatible type in %p1_3d_mini")
     end
     out.#=rand(1)
   end
   
endfunction
