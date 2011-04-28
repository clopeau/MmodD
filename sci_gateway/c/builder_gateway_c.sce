// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

if MSDOS then
  // to manage long pathname
  includes_src_c = '-I""' + get_absolute_file_path('builder_gateway_c.sce') + '../../src/c""'+' '..
                  +'-I""' + get_absolute_file_path('builder_gateway_c.sce') + '../../src/fortran""' ;
else
  includes_src_c = '-I' + get_absolute_file_path('builder_gateway_c.sce') + '../../src/c'+' '..
                  +'-I' + get_absolute_file_path('builder_gateway_c.sce') + '../../src/fortran';
end
if c_link('libitsolve_fortran'),ulink;end;
functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr';'shurgmres';'mshurgmres'];

Files='int'+functions+'.c';
Files=Files';

tbx_build_gateway('itsolve_fortran', [functions 'int'+functions], [Files], ..
                  get_absolute_file_path('builder_gateway_c.sce'), ..
                  ['../../src/fortran/libSparskit';'../../src/c/libScilin'],'',includes_src_c);
                  
clear tbx_build_gateway;
