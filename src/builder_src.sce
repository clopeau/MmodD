// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

src_dir = get_absolute_file_path("builder_src.sce");

tbx_builder_src_lang("fortran", src_dir);
tbx_builder_src_lang("c"      , src_dir);

clear tbx_builder_src_lang;
clear src_dir;
