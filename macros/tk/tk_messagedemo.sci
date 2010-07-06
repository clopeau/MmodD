function tk_messagedemo
//		Demo of tk_choose
	message(1) = 'A test of'
	message(2) = 'tk_message'
	buttons = ['1', '2', '3']
	cmd(1) = 'result=tk_message(message)'
	disp('''tk_message'' display a message and several buttons.')
	disp('It will return the button pressed by the user')
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	mprintf('Result = %i\n\n', result)

	message(1) = 'A test of'
	message(2) = 'the Long form of'
	message(3) = 'tk_message'	
	cmd(1) = 'result=tk_message(message,buttons)'
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	mprintf('Result = %i\n\n', result)

endfunction
