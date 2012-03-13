// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

src_dir = get_absolute_file_path("builder_src.sce");
funcprot(0)
tbx_builder_src_lang("sparskit", src_dir);
tbx_builder_src_lang("scilin"      , src_dir);
funcprot(1)
clear tbx_builder_src_lang;
clear src_dir;
