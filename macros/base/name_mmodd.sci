// Copyright (C) 2010-11 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function %nams=name_mmodd(%in)
   %nams=who('get');
   //global %exclud
   %nams(grep(%nams,'%'))=[];
   %nams=%nams(evstr('type('+%nams+')')==17);
   //%nams(grep(%nams,%exclud))=[]
   //
   //faster than %sel=typeof(%in) 
   %sel=getfield(1,%in);
   %sel=%sel(1);
   %typn="";
   %typn=%typn(ones(%nams));
   for i=1:size(%nams,1)
     %tmp=evstr('getfield(1,'+%nams(i)+')');
     %typn(i)=%tmp(1)
   end
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
 
   
