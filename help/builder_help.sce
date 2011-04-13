// Copyright 2010 David Delanoue
// Copyright 2011 Thierry Clopeau
// This file is released into the public domain
help_dir = get_absolute_file_path('builder_help.sce');
help_dir_US = pathconvert( help_dir ) + "en_US" + filesep();

func=[ '../macros/tri2d/square2d.sci'
       '../macros/tri2d/tri2d.sci'
       '../macros/line2d/line2d.sci'
       '../macros/p1_1d/p1_1d.sci'
       '../macros/p1_2d/p1_2d.sci'
       '../macros/line3d/line3d.sci'];
func=help_dir+"/"+func;
list_func=['square2d' 'tri2d' 'line2d' 'p1_1d' 'p1_2d' 'line3d'];

for i=1:size(func,1)
   mdelete(help_dir_US + list_func(i) + '.xml');
end
 
for i=1:size(func,1)
  execstr('help_from_sci(func(i,1),help_dir_US)');
end

tbx_builder_help_lang("en_US", help_dir);
//tbx_builder_help_lang("fr_FR", help_dir);
//xmltohtml(help_dir_US);
clear help_dir;
