// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

//
// buildmacros.sce --
// Builder for the Modular Modeling
//
funcprot(0)
macrospath=get_absolute_file_path("buildmacros.sce");
listfic=listfiles(macrospath);
%dir=[];
for i=1:size(listfic,1)
  rep=listfic(i,1);
  if(isdir(macrospath+rep))
    %dir($+1)=rep;
  end
end

for i=1:size(%dir,1)
  tbx_build_macros(TOOLBOX_NAME,macrospath+%dir(i));
end
funcprot(1)

//clear tbx_build_macros,files,listfic,%dir,rep,i;
