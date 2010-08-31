functions_f=['ilut','ilu0','lusol','piluc',..
'milu0','qsplit','qsort','qqsort','distdot',..
'ilut','lutsol','pgmres','runrc','iluc','iters','pilucsol',..
'ilucsol','mpgmres','pilucdusol'];
//Files_f=findfiles(get_absolute_file_path('builder_fortran.sce'),'*.f');
Files_f=functions_f+'.f';
tbx_build_src([functions_f], [Files_f], 'f', ..
              get_absolute_file_path('builder_fortran.sce'));

clear tbx_build_src;


