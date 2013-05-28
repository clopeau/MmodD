// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function MmodD_menu()

global %mmodd_path
// menus additionnals
// =============================================================================
if getscilabmode() == ["STD"]
  delmenu('MmodD')
  addmenu('MmodD',['Meshtool';'Vartool';'MmodD update']);
  MmodD(1)="exec("""+%mmodd_path+"/menu/MeshTool.sce"");";
  MmodD(2)="exec("""+%mmodd_path+"/menu/VarTool.sce"");";
  MmodD(3)="mmodd_update();";
  [MmodD]=resume(MmodD)
end

endfunction
