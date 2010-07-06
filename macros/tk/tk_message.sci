function [num]=tk_message(mess, buttons)
//		Replacement of x_message

//		Global record of the depth of the dialog
	global dialog_lv
	dialog_lv = dialog_lv + 1
	my_lv = dialog_lv
	
	[lhs,rhs] = argn(0)
	if rhs==0 then 
		tk_messagedemo()
		num = 0
		return
	end
	if rhs<2 then buttons = 'OK', end
	
	mstr = strcat(mess, '\n')
	bstr = '{' + strcat(buttons, '} {') + '}'
	
//	cmd = sprintf('sci_message ""%s"" ""%s""', mstr, bstr)
	cmd = 'sci_message ' + '""'+mstr+'"" ' + '""'+bstr+'"" '
	TCL_EvalStr('set a [' + cmd + ']')
	str = TCL_GetVar('a')
	num = eval(str) + 1

endfunction
