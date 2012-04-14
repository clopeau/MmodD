// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

locpath=get_absolute_file_path('builder_gateway_sparskit.sce')

if MSDOS then
  // to manage long pathname
  includes_src_c = '-I""' + locpath + '../../src/scilin""'+' '..
                  +'-I""' + locpath + '../../src/sparskit""' ;
else
  includes_src_c = '-I' + locpath + '../../src/scilin'+' '..
                  +'-I' + locpath + '../../src/sparskit';
end
if c_link('libitsolve_fortran'),ulink;end;
functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr';'shurgmres';'mshurgmres'];

Files='int'+functions+'.c';
Files=Files';

tbx_build_gateway('sci_Sparskit', [functions 'int'+functions], [Files], ..
                  locpath, ..
                  ['../../src/sparskit/libSparskit';'../../src/scilin/libScilin'],'',includes_src_c);
                  
clear tbx_build_gateway;
