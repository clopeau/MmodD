// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt



// script to uninstall MmodD inside the atomsAutoLoad
lines(-1);
mmodd_dir=get_absolute_file_path("uninstall.sce");

// Load Atoms Internals lib if it's not already loaded
// =========================================================================
if ~ exists("atomsinternalslib") then
     load("SCI/modules/atoms/macros/atoms_internals/lib");
end

// Readind description
// =========================================================================
package_description = atomsDESCRIPTIONread(mmodd_dir + "DESCRIPTION");
package_name="MmodD";
package_summary=getfield(3,package_description.packages.MmodD);
section="user";

// Removing from the Atoload process
// =========================================================================
atomsAutoloadDel("MmodD","user"); 

// load installed packages (a struct)
// =========================================================================
installed = atomsLoadInstalledStruct(section);

// Load the installed_deps (a struct)
// =========================================================================
installed_deps = atomsLoadInstalleddeps(section);


if isfield(installed,package_name+" - "+package_summary.Version) then
  installed      =atomsRmfields(installed,package_name+" - "+package_summary.Version)
  installed_deps =atomsRmfields(installed_deps,package_name+" - "+package_summary.Version)
  atomsSaveInstalled(installed,section);
  atomsSaveInstalleddeps(installed_deps,section);
else
  disp("MmodD is uninstalled... Nothing to do...")
end


