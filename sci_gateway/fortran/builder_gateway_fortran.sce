functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr'];//'shurgmres';'mshurgmres'];

Files='int'+functions+'.c';
Files=Files';

tbx_build_gateway('itsolve_c', ['fortran_'+functions 'int'+functions], [Files], ..
                  get_absolute_file_path('builder_gateway_fortran.sce'), ..
                  ['../../src/c/libSci2spk'],'',includes_src_c);
clear tbx_build_gateway;
