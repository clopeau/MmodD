function [result] = tk_sortdialog(arg1, arg2, arg3)
//		A dialog for sorting the order of a vector or a list
	[lhs, rhs] =argn(0)
//		Default values
	if rhs>=3 then
		header = arg1
		lbl = arg2
		obj = arg3
	elseif rhs==2 then
		header = arg1
		lbl = ''
		obj = arg2
	elseif rhs==1 then
		header = ''
		lbl = ''
		obj = arg1
	else
		tk_sortdialogdemo()
		result = ''
		return
	end

//		Make some default labels if none is given
	if type(obj)==15 then
		n=size(obj)
	else
		n=size(obj,'*')
	end
	
	if lbl=='' then
		if type(obj)==15 then
			for i=1:n
				lbl(i) = string(obj(i)(1))
			end
		else
			lbl = string(obj)
		end
	end

	hds = strcat(header, '\n')
	lbs = '{' + strcat(lbl, '} {') + '}'
	ids = strcat(string(1:n), ' ')

//	cmd = sprintf('sci_sortdialog ""%s"" ""%s"" ""%s""', hds, lbs, ids)

	cmd = 'sci_sortdialog ' + '""'+hds+'"" ' + '""'+lbs+'"" ' + ...
		'""'+ids+'"" '
	TCL_EvalStr('set a [lindex [' + cmd + '] 1]')
//		idx contains the indices of the elements after rearrangement
	str = TCL_GetVar('a')
	idx = eval(tokens(str, ' '))

//		Rearrange the objects according to the new sequence of indices
	for i=1:n
		result(i) = obj(idx(i))
	end

endfunction
