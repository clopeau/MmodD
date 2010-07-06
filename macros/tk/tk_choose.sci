function [num] = tk_choose(items,header,buttons,multi,nview)
//		Replacement of x_choose using tk interface in Scilab

//		Global record of the depth of dialog
	[lhs,rhs] = argn(0)
	if rhs==0 then tk_choosedemo()
		num = 0
		return
	end
	nitem = size(items,'*')
	if rhs<5 then nview=-1, end		// See all by default
	if rhs<4 then multi=1, end		// Multiple items by default
	if rhs<3 then buttons='', end
	if rhs<2 then header='', end

	if buttons=='' then
		bns = 'OK Cancel'
	elseif size(buttons,'*')==1 then	// For compatibility with x_choose
		bns = 'OK ' + '{' + strcat(buttons,'} {') + '}'
	else
		bns = '{' + strcat(buttons, '} {') + '}'
	end

	disp('Click on any items to select/deselect it.')		
	disp('Ctrl-button 1 for multiple selections.')
	disp('Or button 1 and drag for continuous selections.')
	disp('Press ''Ok'' or ''Cancel'' when you finish')

	its = '{' + strcat(items, '} {') + '}'
	hds = strcat(header, '\n')
//	cmd = sprintf('sci_choose ""%s"" ""%s"" ""%s"" %i %i', hds, its, bns, multi, nview)

	cmd = 'sci_choose ' + '""'+hds+'"" ' + '""'+its+'"" ' + ...
		'""'+bns+'"" ' + '""'+string(multi)+'"" ' + ...
		'""'+string(nview)+'"" '
	TCL_EvalStr('set a [' + cmd + ']')
	str = TCL_GetVar('a')
	if str~='' then
		num = eval(tokens(str, ' '))
		num = num + ones(num)
	else
		num = 0
	end

endfunction
