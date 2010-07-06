//
//	Copyright (C) 2001	Ying-Wan Lam
//


function tk_sortdialogdemo()
//		A demo of 'tk_sortdialog'
	message(1) =  'A test of'
	message(2) = 'tk_sortdialog'
	disp('''tk_sortdialog'' display the content of a list or a vector.')
	disp('and allows interactively rearranging their order.')
	result = list()	
	cmd(1) = 'list1 = list(''Item 1'', ''Item 2'', ''Item 3'')'
	cmd(2) = 'result = tk_sortdialog(list1)'
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	mprintf('Result = \n\n')
	disp(result)
	
	result = []
	cmd(1) = 'labels = [''Item 1'', ''Item 2'', ''Item 3'']'
	cmd(2) = 'matrix1 = [1; 2; 3]' 
	cmd(3) = 'result = tk_sortdialog(message, labels, matrix1)'
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	mprintf('Result = \n\n')
	disp(result)

endfunction
