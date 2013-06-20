// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function action=MmodD_menu_action(k)

// menus additionnals
// =============================================================================
  actions=["exec(mmodd_getpath()+""/menu/MeshTool.sce"");";..
	  "exec(mmodd_getpath()+""/menu/VarTool.sce"");";..
	  "help(''MmodD'');";..
	  "mmodd_update();"]
  if (k >= 1 & k <= size(actions, "*"))
    action = actions(k); 
  else
    action = "";  
  end

endfunction
