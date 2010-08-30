src_c_path = get_absolute_file_path('builder_c.sce');

CFLAGS = "-I" + src_c_path;

tbx_build_src(['Sci2spk','inf_rl','inf_rc','pivot_patern','pivot_real','pivot_complex'], ['conv.c','sort.c'], 'c', ..
              src_c_path, '', '', CFLAGS);

clear tbx_build_src;
clear src_c_path;
clear CFLAGS;
