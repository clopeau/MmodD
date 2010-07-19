// Copyright INRIA 2008
// This file is released into the public domain
help_dir = get_absolute_file_path('builder_help.sce');
help_dir_US = pathconvert( help_dir ) + "en_US" + filesep();

func=[ '../macros/tri2d/square2d.sci'
       '../macros/tri2d/tri2d.sci'
       '../macros/line2d/line2d.sci'];
list_func=['square2d' 'tri2d' 'line2d'];
disp(pwd())
for i=1:size(func,1)
mdelete('en_US/'+ list_func(i) + '.xml');
end
for i=1:size(func,1)
  execstr('help_from_sci(func(i,1),help_dir_US)');
end

tbx_builder_help_lang("en_US", help_dir);
tbx_builder_help_lang("fr_FR", help_dir);
xmltohtml(help_dir_US);
clear help_dir;
