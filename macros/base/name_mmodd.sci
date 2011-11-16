// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %nams=name_mmodd(%in)
   %nams=who('get');
   //global %exclud
   %nams(grep(%nams,'%'))=[]
   //%nams(grep(%nams,%exclud))=[]
   //
   //faster than %sel=typeof(%in)
   %sel=getfield(1,%in);
   %sel=%sel(1);
   %typn=evstr('typeof('+%nams+')');
   %nams=%nams(%typn==%sel)
   if %nams==[]
      %nams="toto"
   else
      %nams=%nams(evstr(%nams+'.#==%in.#'));
      %nams=%nams(1);
   end
   if %nams==""
     %nams="toto"
   end
 endfunction
 
   
