src_c_path = get_absolute_file_path('builder_c.sce');

CFLAGS = "-I" + src_c_path;

functions_c=['lband';'eltm';'Spk2sci';'spluget';'Sci2spk';'NewSpk'];

files_c=functions_c+'.c';
//,'inf_rl','inf_rc','pivot_patern','pivot_real','pivot_complex'
tbx_build_src([functions_c], [files_c], 'c', ..
              src_c_path, '', '', CFLAGS);

clear tbx_build_src;
clear src_c_path;
clear CFLAGS;
