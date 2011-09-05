// Copyright 2010 David Delanoue
// Copyright 2011 Thierry Clopeau
// This file is released into the public domain
help_dir = get_absolute_file_path('builder_help.sce');
help_dir_US = pathconvert( help_dir ) + "en_US" + filesep();

// --- for retro-compatibility 
mdelete(help_dir_US+'*.xml');
// ---- to be deleted

//
//MmodD Types/Mesh 
//
//Rep="MmodDType/Mesh/"

//Function=['tri2d', 'square2d', 'tet3d', 'tcube3d'];

//File_Func=['../macros/tri2d/tri2d.sci', '../macros/tri2d/square2d.sci', ..
//	   '../macros/tet3d/tet3d.sci', '../macros/tet3d/tcube3d.sci'];

//for i=1:size(Function,2)
  // for compatible evolution
//  mdelete(help_dir_US+ Function(i) + '.xml');
  // 
//  mdelete(help_dir_US+Rep+ Function(i) + '.xml');
//  execstr('help_from_sci(help_dir+File_Func(i),help_dir_US+Rep)');
//end

//
//Mmodd Types/Mesh/ReadFunction
//
// To do
// read_tri2d_XXX
// read_tri3d_XXX

//
// MmodD Types/EDP
//

//
// MmodD Types/EDP/SymbolicOperator/
//
//
//Rep="MmodDType/EDP/SymbolicOperator/";

//Function=['Laplace', 'Id', 'kLaplace', 'kId'..
//	  'Dx' 'Dy' 'Dz' 'D2x' 'D2y' 'D2z'..
//	  'ConvDx' 'ConvDy' 'ConvDz' 'ConvGrad'..
//	 'Dn'];

//File_Func=['../macros/edp/Laplace.sci',..
//	   '../macros/edp/Id.sci',..
//	   '../macros/edp/kLaplace.sci',..
//	   '../macros/edp/kId.sci',..
//	   '../macros/edp/Dx.sci',..
//	   '../macros/edp/Dy.sci',..
//	   '../macros/edp/Dz.sci',..
//	   '../macros/edp/D2x.sci',..
//	   '../macros/edp/D2y.sci',..
//	   '../macros/edp/D2z.sci',..
//	   '../macros/edp/ConvDx.sci',..
//	   '../macros/edp/ConvDy.sci',..
//	   '../macros/edp/ConvDz.sci',..
//	   '../macros/edp/ConvGrad.sci'..
//	   '../macros/edp/Dn.sci'];

//for i=1:size(Function,2)
//  mdelete(help_dir_US+Rep+ Function(i) + '.xml');
//  execstr('help_from_sci(help_dir+File_Func(i),help_dir_US+Rep)');
//end

//
// MmodD Types/Variables
//
//Rep="MmodDType/Variables/"

//Function=['p1_2d', 'p1_3d', 'Grad'];

//File_Func=['../macros/p1_2d/p1_2d.sci', '../macros/p1_3d/p1_3d.sci' ..
//	  '../macros/edp/Grad.sci'];

//for i=1:size(Function,2)
//  mdelete(help_dir_US+Rep+ Function(i) + '.xml');
//  execstr('help_from_sci(help_dir+File_Func(i),help_dir_US+Rep)');
//end

//
// Tools
//
// paraview
		

//
// Effective help building

tbx_builder_help_lang("en_US", help_dir);

clear help_dir Rep Function File_Func;
