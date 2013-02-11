// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

locpath=get_absolute_file_path('builder_gateway_sparskit.sce')

if getos()=="Windows" then
  // to manage long pathname
  includes_src_c = '-I""' + locpath + '..\..\src\scilin""'+' '..
                  +'-I""' + locpath + '..\..\src\sparskit""' ;
  libs=['..\..\src\sparskit\libSparskit';'..\..\src\scilin\libScilin']
else
  includes_src_c = '-I' + locpath + '../../src/scilin'+' '..
                  +'-I' + locpath + '../../src/sparskit';
  libs=['../../src/sparskit/libSparskit';'../../src/scilin/libScilin']
end
	    
if c_link('libsci_Sparskit'),ulink;end;
	    
functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr';'shurgmres';'mshurgmres'];

Files='int'+functions+'.c';
Files=Files';

tbx_build_gateway('sci_Sparskit', [functions 'int'+functions], [Files], ..
                  locpath, libs ,'',includes_src_c);
                  
clear tbx_build_gateway;
