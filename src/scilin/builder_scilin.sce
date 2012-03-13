// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

src_c_path = get_absolute_file_path('builder_scilin.sce');

CFLAGS = "-I" + src_c_path;

functions_c=['lband';'eltm';'Spk2sci';'spluget';'Sci2spk'];

files_c=functions_c+'.c';
tbx_build_src([functions_c], [files_c], 'c', ..
    src_c_path, '', '', CFLAGS,'','','Scilin');

clear tbx_build_src;
clear src_c_path;
clear CFLAGS;
