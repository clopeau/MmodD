
src_dir = get_absolute_file_path("builder_src.sce");
//gateway=ls(src_dir+'sci_gateway/*.c')';
//java_home=jre_path();
//include='-I'+here+'/include -I'+java_home+'include'+' -I'
//sci_gtw=['loadClass

tbx_builder_src_lang("fortran", src_dir);
tbx_builder_src_lang("c"      , src_dir);

clear tbx_builder_src_lang;
clear src_dir;
