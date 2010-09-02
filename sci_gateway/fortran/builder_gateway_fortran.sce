if MSDOS then
  // to manage long pathname
  includes_src_c = '-I""' + get_absolute_file_path('builder_gateway_fortran.sce') + '../../src/c""';
else
  includes_src_c = '-I' + get_absolute_file_path('builder_gateway_fortran.sce') + '../../src/c';
end

functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr'];//'shurgmres';'mshurgmres'];

Files='int'+functions+'.c';
Files=Files';

tbx_build_gateway('itsolve_fortran', ['fortran_'+functions 'int'+functions], [Files], ..
                  get_absolute_file_path('builder_gateway_fortran.sce'), ..
                  ['../../src/c/liblband'],'',includes_src_c);
                  
clear tbx_build_gateway;
