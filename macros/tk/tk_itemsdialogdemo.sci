//
//	Copyright (C) 2001	Ying-Wan Lam
//


function tk_itemsdialogdemo()
//		A demo of 'tk_itemsdialog'
	message(1) =  'A test of'
	message(2) = 'tk_itemsdialog'
	disp('''tk_itemsdialog'' provide an interface to display the content')
	disp('of a list or a vector; and allows interactively adding and ')
	disp('deleting elements or rearranging their order.')
	result = list()	
	cmd(1) = 'm = [''item 1''; ''item 2''; ''item 3'']'
	cmd(2) = 'result = tk_itemsdialog(m)'
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	mprintf('Result = \n\n')
	disp(result)
	
	result = []
	cmd(1) = 'headers = [''Testing of tk_itemsdialog'']'
	cmd(2) = 'm = [''item 1''; ''item 2''; ''item 3'']' 
	cmd(3) = 'result = tk_itemsdialog(headers, m)'
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	mprintf('Result = \n\n')
	disp(result)

endfunction
