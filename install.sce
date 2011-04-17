// Copyright (C) 2011 - Thierry Clopeau
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
//package=package_description("MmodD");
package=package_description;
//package_version = getfield(1,package);
package_summary=getfield(3,package.packages.MmodD);
new_package_description = atomsDESCRIPTIONaddField( ..
                package, ..
                package_name,        ..
                package_summary.Version,     ..
                "fromRepositery",     ..
                mmodd_dir);
    

 sysdir=atomsPath("system" ,"user");
 
// //bug ou choix de programmation
// //les packages d'une version antérieure (par ex:5.2.2 ) sont souvent présents dans le dossiser temporaire
// //lors de l'installation d'une nouvelle version: ces dossiers ne sont pas supprimés, pour qu'on puisse toujours charger les modules installés?
// //du coup load packages doit parcourir chacun des dossiers temporaires recherchant celui qui contient "packages"
// sysdir_Sci=strsplit(sysdir,strindex(sysdir,'Scilab')+5);
// sysdir_version=findfiles(sysdir_Sci(1));
// for i=1:size(sysdir_version,1)
//     if fileinfo(sysdir_Sci(1)+'\'+sysdir_version(i)+'\.atoms\packages')~=[]
//         load(sysdir_Sci(1)+'\'+sysdir_version(i)+'\.atoms\packages');
//     end
// end

load(sysdir+"packages");




 
