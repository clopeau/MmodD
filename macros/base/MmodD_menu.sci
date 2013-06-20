// Copyright (C) 2011 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function MmodD_menu()

global %mmodd_path
// menus additionnals
// =============================================================================
if getscilabmode() == ["STD"]
  labels=['Meshtool';..
	  'Vartool';..
	  'Help';..
	  'MmodD update'];
  
  delmenu('MmodD')
  addmenu('MmodD',labels,list(0,"MmodD_menu_action"));
end

endfunction
