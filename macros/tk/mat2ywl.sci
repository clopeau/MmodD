function str=mat2ywl(m)
//		Concatenate a matrix into a string following MY :) convention. 
//		Used for parameter passing between Scilab and Tk/Tcl. 

	ty = type(m)
	ts = part(typeof(m),[1:3])
	if ty==8 then						// integer subtypes
		ty = ts + string(inttype(m))
	end
	if ty==4 then						// boolean
		s = strcat(string(bool2s(m)), '|')
	else
		s = strcat(string(m), '|')
	end
	str = ts + '|' + string(size(m,'r')) + '|' + ...
		string(size(m,'c')) + '|' + s
	
endfunction
