function tk_choosedemo
//		Demo of tk_choose
	title(1) = 'A test of'
	title(2) = 'tk_choose'
	cmd(1) = 'items = [''Item 1'',''Item 2'',''Item 3'',''Item 4'']'
	cmd(2) = 'result=tk_choose(items)'	
	disp('''tk_choose'' provide a dialog to choose from a list of items.')
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	disp(string(result), 'Result =')
	
	cmd(1) = 'result=tk_choose(items,title)'
	cmd(2) = []	
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	disp(string(result), 'Result =')

endfunction
