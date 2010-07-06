//
//	Copyright (C) 2001	Ying-Wan Lam
//


function tk_dialogdemo
//		Demo fo tk_dialog
	lbv = ['Row 1', 'Row 2', 'Row 3', 'Row 4', 'Row 5']
	lbh = ['Col 1', 'Col 2', 'Col 3', 'Col 4', 'Col 5']
	title(1) = 'A test of' 
	title(2) = 'tk_dialog'
	
	disp('''tk_dialog'' can be used for input and edit of matrix.')
	cmd(1) = 'result=tk_dialog(matrix(1:20,5,4))'
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	disp(result)
		
	cmd(1) = 'result=tk_dialog(title,lbv,lbh, matrix(1:20,5,4))'
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	disp(result)
	
	disp('Or a list')
	cmd(1) = 'result=tk_dialog(list(1,''aa'',[1:4]''))'
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	disp(result)
	
	cmd(1)='result=tk_dialog(title,lbv,lbh, list(1,''aa'',%t,[1:4]'',list(1,2,3)))'
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	disp(result)

	cmd(1)='result=tk_dialog(tlist([''Test'',''a'',''b'',''c''], 2,%t,''Test''))'
	disp('Or a typed list')
	disp(cmd)
	execstr(cmd)
	disp(result)

endfunction
