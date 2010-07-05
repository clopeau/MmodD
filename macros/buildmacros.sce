//Clopeau Thierry, Delanoue David, Ndeffo Marcel & Smatti Sofian
// This file is released into the public domain

//
// buildmacros.sce --
// Builder for the Modular Modeling
//
files=get_absolute_file_path("buildmacros.sce");
listfic=listfiles(files);
for i=1:length(length(listfic,1))
	rep=listfic(i,1)
	if(isdir(rep))
	dir(i)=rep
	end
end

getd(files)
num=length(length(dir,1)),
for i=1:num
	if(strcmp(dir(i,1)," ")<>0.0)	
	u1=file('open',files+"/"+dir(i,1)+"buildmacros.sce",'new')
	write(u1,"tbx_build_macros(TOOLBOX_NAME,get_absolute_file_path("buildmacros.sce"));\n getd()");
end
tbx_build_macros(TOOLBOX_NAME,files);
tbx_builder_macros(TOOLBOX_NAME,files);

clear tbx_build_macros,files,listfic;
