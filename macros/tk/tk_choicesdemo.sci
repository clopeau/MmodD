//
//	Copyright (C) 2001	Ying-Wan Lam
//


function tk_choicesdemo
//		Demo of tk_choicesdemo
	title(1) = 'A test of'
	title(2) = 'tk_choice'
	labels = ['Row 1', 'Row 2', 'Row 3']

	cmd(1) = 'r1 = string(1:5)'
	cmd(2) = 'r2 = [''a'',''b'',''c'']'
	cmd(3) = 'r3 = [''Choice 1'', ''Choice 2'']'
	cmd(4) = 'result = tk_choices(list(r1,r2,r3))'
	disp('''tk_choices'' allows perform several choices at the')
	disp('same time using radio buttons/checkboxes')
	disp('Short form:')
	disp(cmd)
	execstr(cmd)
	disp(result)

	cmd(1) = 'result=tk_choices(title,labels,list(r1,r2,r3),[3,2,1],%f)'
	cmd(2) = []
	cmd(3) = []
	cmd(4) = []
	disp('Long form:')
	disp(cmd)
	execstr(cmd)
	disp(result)

endfunction
