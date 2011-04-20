// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt



// script to install MmodD from the local repertory
lines(-1);
mmodd_dir=get_absolute_file_path("install.sce");

// build from source
// =========================================================================
exec(mmodd_dir+"builder.sce");

// Load Atoms Internals lib if it's not already loaded
// =========================================================================
if ~ exists("atomsinternalslib") then
     load("SCI/modules/atoms/macros/atoms_internals/lib");
end


// Create needed directories
// =========================================================================
atoms_system_directory  = atomsPath("system" ,"user");
atoms_install_directory = atomsPath("install","user");

directories2create = [  atoms_system_directory ;   ..
		    atoms_install_directory  ];

for i=1:size(directories2create,"*")
  if ~ isdir( directories2create(i) ) & (mkdir( directories2create(i) ) <> 1) then
    error(msprintf( ..
		    gettext("%s: The directory ''%s'' cannot been created, please check if you have write access on this directory.\n"),..
		    directories2create(i)));
  end
end

// Readind description
// =========================================================================
package_description = atomsDESCRIPTIONread(mmodd_dir + "DESCRIPTION");
package_name="MmodD";
package_summary=getfield(3,package_description.packages.MmodD);
section="user";

// load installed packages (a struct)
// =========================================================================
installed = atomsLoadInstalledStruct(section);

// Load the installed_deps (a struct)
// =========================================================================
installed_deps = atomsLoadInstalleddeps(section);

// Does the SCIHOME/atoms/autoloaded exist, if yes load it
// =========================================================================
autoloaded = atomsAutoloadLoad(section);


if isfield(installed,package_name+" - "+package_summary.Version) then
  // This package is already registered
  disp("MmodD is already installed... Nothing to do...")
else
  installed(package_name+" - "+package_summary.Version)=[ ..
	  package_name ;..
	  package_summary.Version ;..
	  strncpy(mmodd_dir,length(mmodd_dir)-1) ;..
	  "user";..
	  "I"];
  installed_deps(package_name+" - "+package_summary.Version) = [];

  autoloaded = [autoloaded; ["MmodD" package_summary.Version "user"]];
  
  atomsSaveInstalled(installed,section);
  atomsSaveInstalleddeps(installed_deps,section);
  atomsAutoloadSave(autoloaded,section);
  atomsInstallRegister(package_name,package_summary.Version,"I","user");
end



