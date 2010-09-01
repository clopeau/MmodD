functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr'];//'shurgmres';'mshurgmres'];

Files='int'+functions+'.c';
Files=Files';

tbx_build_gateway('itsolve_fortran', ['fortran_'+functions 'int'+functions], [Files], ..
                  get_absolute_file_path('builder_gateway_fortran.sce'), ..
                  ['../../src/c/libitsolve_fortran'],'',includes_src_c);
clear tbx_build_gateway;
