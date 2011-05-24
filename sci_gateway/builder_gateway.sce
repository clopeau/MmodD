// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 
funcprot(0)

sci_gateway_dir = get_absolute_file_path('builder_gateway.sce');
tbx_builder_gateway_lang('c', sci_gateway_dir);

languages = ['c'];
tbx_build_gateway_loader(languages, sci_gateway_dir);
tbx_build_gateway_clean(languages, sci_gateway_dir);

funcprot(1)
clear tbx_builder_gateway_lang tbx_build_gateway_loader;
clear sci_gateway_dir;

