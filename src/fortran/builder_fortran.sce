Files_f=findfiles(get_absolute_file_path('builder_fortran.sce'),'*.f');
functions_f=Files_f;
for i=1:size(Files_f,1)
  functions_f(i)=part(functions_f(i),1:length(functions_f(i))-2);
end

tbx_build_src([functions_f], [Files_f], 'f', ..
              get_absolute_file_path('builder_fortran.sce'));

clear tbx_build_src;


