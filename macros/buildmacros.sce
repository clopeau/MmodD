//Clopeau Thierry, Delanoue David, Ndeffo Marcel & Smatti Sofian
// This file is released into the public domain

//
// buildmacros.sce --
// Builder for the Modular Modeling
//
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

//clear tbx_build_macros,files,listfic,%dir,rep,i;
