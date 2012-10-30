// Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function out=%p0_3d_max(in,in2)
   [lhs,rhs]=argn(0);
   if rhs==1
     out=max(in.Cell,'r');
   else
     if typeof(in)=="p0_3d" & typeof(in2)=="p0_3d"
       out=in
       out.Cell=max(in.Cell,in2.Cell)
       out.Id="max("+in.Id+","+in2.Id+")";
     elseif  typeof(in)=="p0_3d" & type(in2)==1
       out=in;
       out.Cell=max(in.Cell,in2)
       out.Id="max("+in.Id+","+string(in2)+")";
     elseif  type(in)==1 & typeof(in2)=="p0_3d"
       out=in2;
       out.Cell=max(in,in2.Cell)
       out.Id="max("+string(in)+","+in2.Id+")";
     else
       error("Incompatible type in %p0_3d_maxi")
     end
     out.#=rand(1)
   end
   
endfunction
