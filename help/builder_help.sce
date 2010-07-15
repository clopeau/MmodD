// Copyright INRIA 2008
// This file is released into the public domain
help_dir = get_absolute_file_path('builder_help.sce');
//////
////////listfic = listfiles(macrospath);
////////%dir=[];
////////for i = 1:size(listfic,1)
//////  //rep = listfic(i,1);
//////  //if(isdir(macrospath+rep))
//////    //%dir($+1) = rep;
//////    //execstr('help_from_sci('rep','help_dir')');
//////  //end
////////end
////////execstr('help_from_sci(macro_dir,)');
//////
tbx_builder_help_lang("en_US", help_dir);
tbx_builder_help_lang("fr_FR", help_dir);
clear help_dir;
