// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

try
  v = getversion('scilab');
catch
  v = [ 5 0 ]; // or older 
end
if (v(1) <= 5) & (v(2) < 2) then
  // new API in scilab 5.2
  error(gettext('Scilab 5.2 or more is required.'));
end

src_dir = get_absolute_file_path('loader_src.sce');
current_dir     = pwd();

chdir(src_dir);
if ( isdir('c') ) then
  chdir('c');
  exec('loader.sce');
end

chdir(src_dir);
if ( isdir('fortran') ) then
  chdir('fortran');
  exec('loader.sce');
end

chdir(src_dir);
if ( isdir('cpp') ) then
  chdir('cpp');
  exec('loader.sce');
end

chdir(current_dir);
// ====================================================================
clear src_dir;
clear current_dir;
// ====================================================================
