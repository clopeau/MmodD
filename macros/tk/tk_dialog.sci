function [result] = tk_dialog(arg1, arg2, arg3, arg4)
//		Substitution of x_mdialog and x_dialog

	[lhs,rhs] = argn(0)
	if rhs>=4 then
//		A matrix, arg2 is labelsv, arg3 is labelsh, arg4 is the default
		header = arg1
		labelsv = arg2
		labelsh = arg3
		default = arg4
	elseif rhs==3 then
//		A vector, arg2 is the label, arg3 is the default
		header = arg1
		labelsv = arg2
		labelsh = ''
		default = arg3
	elseif rhs==2 then					// typed list?
		header = ''
		labelsv = arg1
		labelsh = ''
		default = arg2
	elseif rhs==1 then
		header = ''
		labelsv = ''
		labelsh = ''
		default = arg1
	else
		tk_dialogdemo()
		result = []
		return
	end

	select type(default)
		case 15 then
			str = list2ywl(default)
		case 16 then 
			str = list2ywl(default)		
		case 1 then 					// Number
			str = mat2ywl(default)
		case 8 then					// Integer
			str = mat2ywl(default)
		case 4 then					// Boolean
			str = mat2ywl(default)
		case 10 then					// string
			str = mat2ywl(default)
		else
			result=[]
			disp('tk_dialog: object type not supported')
			return
	end

	hds = strcat(header, '\n')
//	hds = header + '\n')
	if labelsv ~= '' then 
		lsv = '{' + strcat(labelsv, '} {') + '}'
	else
		lsv = ''
	end
	if labelsh ~= '' then 
		lsh = '{' + strcat(labelsh, '} {') + '}'
	else
		lsh = ''
	end
//	cmd = msprintf('sci_dialog ""%s"" ""%s"" ""%s"" ""%s""',hds, lsv, lsh, str)

	cmd = 'sci_dialog ' + '""'+hds+'"" ' + '""'+lsv+'"" ' + ...
		'""'+lsh+'"" ' + '""'+str+'"" '	
	TCL_EvalStr('set sci_lv -1; set a [' + cmd + ']')
	str = TCL_GetVar('a')

	select type(default)
		case 15 then
			if str=='' then result=list(); else result = ywl2list(str); end
		case 16 then 
			if str=='' then result=list(); else result = ywl2list(str); end
		else
		 	if str=='' then result=[]; else result = ywl2mat(str); end
	end

endfunction
