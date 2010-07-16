// Copyright INRIA 2008
// This file is released into the public domain
help_dir = get_absolute_file_path('builder_help.sce');
//disp(pwd())
func=['square2d.sci' 'macros/tri2d'
       ];
nb=[1,2];
for i=1:size(func,1)

for i=1:nb(i)
  execstr('cd ../')
  //disp('done!');
end
  execstr('cd '+func(i,2));  
  execstr('help_from_sci(func(i,1),help_dir)'); 
end
//--New modif
//xmltojar(help_dir);

tbx_builder_help_lang("en_US", help_dir);
tbx_builder_help_lang("fr_FR", help_dir);
clear help_dir;
