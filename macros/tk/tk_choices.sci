//
//	Copyright (C) 2001	Ying-Wan Lam
//

function [result] = tk_choices(arg1,arg2,arg3,defaults,align)
//			tk_choices(title, labels, choices, defaults, alignment)
//			tk_choices(title, labels, choices, defaults)
//			tk_choices(title, labels, choices)
//			tk_choices(title, choices)
//			tk_choices(choices)
	[lhs,rhs] = argn(0)
	if rhs<5 then align=%f, end
	if rhs>=3 then
		header = strcat(arg1,'\n')
		labels = arg2
		choices = arg3
		if rhs<4 then defaults = ones(size(choices),1); end
	elseif rhs==2 then
		align = %f
		header = strcat(arg1,'\n')
		choices = arg2
		labels = ''
		defaults = ones(size(choices),1)
	elseif rhs==1 then
		choices = arg1
		align = %f
		header = ''
		labels = ''
		defaults = ones(size(choices),1)
	elseif rhs==0 then
		tk_choicesdemo()
		result = []
		return
	end

	hds = strcat(header, '\n')
	if labels ~= "" then 
		lbs = '{' + strcat(labels, '} {') + '}'
	else
		lbs = labels
	end
	chs = ''
	n = size(choices)				// # of choices
	for i=1:n
		chs = chs + '{{' + strcat(choices(i), '} {') + '}} '
	end
	dfs = string(defaults - ones(defaults))	// Tk indices start at zeroes
	dfs = strcat(dfs, ' ')
	als = string(bool2s(align))
	
//	cmd = sprintf('sci_choices ""%s"" ""%s"" ""%s"" ""%s"" ""%s""', hds, lbs, chs, dfs, als)

	cmd = 'sci_choices ' + '""'+hds+'"" ' + '""'+lbs+'"" ' + ...
		'""'+chs+'"" ' + '""'+dfs+'"" ' + '""'+als+'"" '
	 TCL_EvalStr('set a [' + cmd + ']')
	 str = TCL_GetVar('a')
//MGmodif
//         result = evstr(str);
	 result = eval(tokens(str, ' '))
	 result = result + ones(result)		// Tk indices start at zeroes

endfunction
