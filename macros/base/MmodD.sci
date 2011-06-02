// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function MmodD()

global %mmodd_path
// menus additionnals
// =============================================================================
if getscilabmode() == ["STD"]
  delmenu('Mmodd')
  addmenu('Mmodd',['meshtool';'vartool']);
  Mmodd(1)="exec("""+%mmodd_path+"/menu/MeshTool.sce"");";
  Mmodd(2)="exec("""+%mmodd_path+"/menu/VarTool.sce"");";
  [Mmodd,%mmodd_path]=resume(Mmodd,%mmodd_path)
end

endfunction
