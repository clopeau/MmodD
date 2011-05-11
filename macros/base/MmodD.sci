// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function MmodD()

global %mmodd_path
// menus additionnals
// =============================================================================
if getscilabmode() == ["STD"]
  //delmenu('toolboxes');
  //delmenu('Help');
  //delmenu('Demos');
  
  delmenu('Mesh')
  addmenu('Mesh',['New mesh';'View mesh';'Load mesh';'Export mesh']);
    //addmenu('Mesh',['Load mesh';'View mesh']);
  //delmenu('Editor')
  //addmenu("Editor",list(2,"editor"));
  //addmenu("Help",["Help browser","Apropos","Configure"],list(2,"help_menu"));
  Mesh(1)="exec("""+%mmodd_path+"/menu/Mesh_New.sce"");";
  Mesh(3)="exec("""+%mmodd_path+"/menu/Mesh_Load.sce"");";
  Mesh(2)="exec("""+%mmodd_path+"/menu/Mesh_View.sce"");";
  Mesh(4)="exec("""+%mmodd_path+"/menu/Mesh_Export.sce"");";
//   delmenu('Variable');
//  addmenu('Variable',['New Var';'Load Var';'View Var';'Export Var';'Edit Var']);
//  
//  Variable(1)="exec "+%mmodd_path+"/menu/Var_New.sce;";
//  Variable(2)="exec "+%mmodd_path+"/menu/Var_load.sce;";
//  Variable(3)="exec("""+%mmodd_path+"/menu/Var_View.sce"");";
//  Variable(4)="exec "+%mmodd_path+"/menu/Var_Export.sce;";
//  Variable(5)="exec "+%mmodd_path+"/menu/Var_Edit.sce;"; 
  
   delmenu('Edp')
   addmenu('Edp',['New edp';'Edit edp';'Export Edp';'Load edp']);
   Edp(1)="exec "+%mmodd_path+"/menu/Var_New.sce;";
   Edp(4)="exec "+%mmodd_path+"/menu/Edp_Load.sce;";
   //Edp(3)="exec("""+%mmodd_path+"/menu/Var_View.sce"");";
   Edp(3)="exec "+%mmodd_path+"/menu/Edp_Export.sce;";
   Edp(2)="exec "+%mmodd_path+"/menu/Edp_Edit.sce;"; 
  
  
  delmenu('Post_Processing')
  addmenu('Post_Processing',['View solution'])
  Post_Processing(1)="exec("""+%mmodd_path+"/menu/Var_View.sce"");";

  [Mesh,Edp,Post_Processing]=resume(Mesh,Edp,Post_Processing)
end

endfunction
