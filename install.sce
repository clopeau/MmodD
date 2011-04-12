// Copyright (C) 20111 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


lines(-1);
// script to install MmodD from the local repertory
packages="MmodD";
version="0.0";

MyPWD=pwd();

// the source directory is not copied...
// =========================================================================
mmodd_dir=get_absolute_file_path("install.sce");

// build from source
// =========================================================================
exec(mmodd_dir+"builder.sce");

// Load Atoms Internals lib if it's not already loaded
// =========================================================================
if ~ exists("atomsinternalslib") then
     load("SCI/modules/atoms/macros/atoms_internals/lib");
end

// Get scilab version (needed for later)
// =========================================================================
sciversion = strcat(string(getversion("scilab")) + ".");


// Operating system detection + Architecture detection
// =========================================================================
[OSNAME,ARCH,LINUX,MACOSX,SOLARIS,BSD] = atomsGetPlatform();


// Complete packages matrix with empty columns
// =========================================================================

atomsDisp(msprintf("\tInstalling %s (%s) ...",packages, ...
		   version));

// Create needed directories
// =========================================================================
Atoms_system_directory  = atomsPath("system" ,"user");
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
package_description = atomsDESCRIPTIONread(mmodd_dir + "DESCRIPTION")
package=package_description("MmodD");
package_name="MmodD";
package_version = getfield(1,package);
new_package_description = atomsDESCRIPTIONaddField( ..
                package, ..
                package_name,        ..
                package_version,     ..
                "fromRepositery",     ..
                mmodd_dir);
    


 sysdir=atomsPath("system" ,"user");
load(sysdir+"packages");




 
