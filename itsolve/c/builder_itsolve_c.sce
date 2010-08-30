
if MSDOS then
  // to manage long pathname
  includes_src_c = '-I""' + get_absolute_file_path('builder_itsolve_c.sce') + '../../src/c""';
else
  includes_src_c = '-I' + get_absolute_file_path('builder_itsolve_c.sce') + '../../src/c';
end

// PutLhsVar managed by user in sci_sum and in sci_sub
// if you do not this variable, PutLhsVar is added
// in gateway generated (default mode in scilab 4.x and 5.x)
WITHOUT_AUTO_PUTLHSVAR = %t;
functions=['splsolve';'spusolve';'triangular';...
	'pgmres';'pgc';'pbgc';'pdbgc';'pgcnr';...
	'pbcgstab';'pqmr';'shurgmres';'mshurgmres'];
Files='int'+functions+'.c';
tbx_build_gateway('itsolve_c', [functions], [Files], ..
                  get_absolute_file_path('builder_itsolve_c.sce'), ..
                  ['../../src/c/libisolve'],'',includes_src_c);

clear WITHOUT_AUTO_PUTLHSVAR;

clear tbx_build_gateway;
