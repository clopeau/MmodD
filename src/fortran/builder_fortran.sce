functions_f=['ilut','lusol','piluc','qsort','qqsort','distdot',..
'ilut','lutsol','pgmres','runrc','iluc','iters','pilucsol',..
'ilucsol','mpgmres','pilucdusol'];
Files_f=findfiles(get_absolute_file_path('builder_fortran.sce'),'*.f');
tbx_build_src([functions_f], [Files_f], 'f', ..
              get_absolute_file_path('builder_fortran.sce'));

clear tbx_build_src;


