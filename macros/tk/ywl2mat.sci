function [m] = ywl2mat(str)
//		Convert a string into MY :) convention back to the matrix.
//		Used for parameter passing between Scilab and Tk/Tcl. 

	v = tokens(str, '|')
	ty = convstr(v(1), 'l')			// Data type
	nr = eval(v(2))				// # Columns
	nc = eval(v(3))				// # Rows
	if nr==0 & nc==0 then			// Special case of empty matrix
		m = []
		return
	end
	contents = v(4:size(v,'*'))
	select ty
		case 'con' then m=evstr(contents)
		case 'boo' then m=evstr(contents)>0
		case 'int1' then m=iconvert(evstr(contents),1)
		case 'int2' then m=iconvert(evstr(contents),1)
		case 'int4' then m=iconvert(evstr(contents),4)
		case 'int11' then m=iconvert(evstr(contents),11)
		case 'int12' then m=iconvert(evstr(contents),12)
		case 'int14' then m=iconvert(evstr(contents),14)
		case 'str' then m=contents
		else error('Error in ywl2mat: Data type not supported')
	end
	m=matrix(m,nr,nc)
			
endfunction
