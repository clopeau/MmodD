function [result] = tk_itemsdialog(arg1, arg2)
//		Present a dialog to allow rearrange an array;
//		adding or deleting elements.
	[lhs,rhs] = argn(0)
	if rhs==0 then 
		tk_itemsdialogdemo()
		result=''
		return
	elseif rhs==1 then
		header = ''
		items = arg1
	elseif rhs>=2 then
		header = arg1
		items = arg2
	end
	
	hds = strcat(header, '\n')
	lbs = '{' + strcat(items, '} {') + '}'

//	cmd = sprintf('sci_itemsdialog ""%s"" ""%s""', hds, lbs)
	cmd = 'sci_itemsdialog ' + '""'+hds+'"" ' + '""'+lbs+'"" '
	TCL_EvalStr('set a [join [' + cmd + '] |]')
	result = tokens(TCL_GetVar('a'), '|')

endfunction
