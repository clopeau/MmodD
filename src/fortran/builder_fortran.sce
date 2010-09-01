//functions_f=['ilut','ilu0','lusol','piluc',..
//'milu0',,..
//,'pgmres','runrc','iluc','iters','pilucsol',..
//'ilucsol','pilucdusol'];
//Files_f=findfiles(get_absolute_file_path('builder_fortran.sce'),'*.f');
functions_f=['ilucsol','distdot','qsort2','qqsort'];
//les fonctions qui ne marchent pas
//'mpgmres','pilucdusol','piluc','qsplit','runrc','lutsol'
Files_f=functions_f+'.f';
tbx_build_src([functions_f], [Files_f], 'f', ..
              get_absolute_file_path('builder_fortran.sce'));
//tbx_build_src(['ilut'], ['ilut.f','ilut.h'], 'f',get_absolute_file_path('builder_fortran.sce'));

clear tbx_build_src;


