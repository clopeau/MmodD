// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

locpath=get_absolute_file_path('builder_gateway_mmodd.sce')

if MSDOS then
  // to manage long pathname
  includes_src_c = '-I""' + locpath + '../../src/mmodd""';
else
  includes_src_c = '-I' + locpath + '../../src/mmodd';
end
if c_link('libMmodD'),ulink;end;
functions=['tri2ed'];

Files='sci_'+functions+'.c';
Files=Files';

tbx_build_gateway('sci_MmodD', [functions 'sci_'+functions], [Files], ..
                  locpath, ..
                  ['../../src/mmodd/libMmodD'],'',includes_src_c);
                  
clear tbx_build_gateway;
