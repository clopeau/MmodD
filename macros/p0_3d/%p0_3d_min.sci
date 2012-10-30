// Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=%p0_3d_min(in,in2)
   [lhs,rhs]=argn(0);
   if rhs==1
     out=min(in.Cell,'r');
   else
     if typeof(in)=="p0_3d" & typeof(in2)=="p0_3d"
       out=in
       out.Cell=min(in.Cell,in2.Cell)
       out.Id="min("+in.Id+","+in2.Id+")";
     elseif  typeof(in)=="p0_3d" & type(in2)==1
       out=in;
       out.Cell=min(in.Cell,in2)
       out.Id="min("+in.Id+","+string(in2)+")";
     elseif  type(in)==1 & typeof(in2)=="p0_3d"
       out=in2;
       out.Cell=min(in,in2.Cell)
       out.Id="min("+string(in)+","+in2.Id+")";
     else
       error("Incompatible type in %p0_3d_mini")
     end
     out.#=rand(1)
   end
   
endfunction
