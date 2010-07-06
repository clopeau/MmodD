function str=list2ywl(l, lv)
//		Concatenate a list into a string following MY :) convention.
//		Used for parameter passing between Scilab and Tk/Tcl.

	if ~exists('lv','local') then lv=0; end		// Start at root by default
	c = '@'+string(lv)+'@'					// String separater
	ty = type(l)
	if ty==15 then							// List
		str = 'list' + c
	elseif ty==16 then						// Typed List
		str = 'tlis' + c
	else									// Neither
		str = mat2ywl(l)					// Assumed that it's a matrix
		return
	end
	n = size(l)
	for i=[1:n]
		x = l(i)
		select type(x)
			case 1 then s=mat2ywl(x)			// Constant
			case 4 then s=mat2ywl(x)			// Boolean
			case 8 then s=mat2ywl(x)			// Integer
			case 10 then s=mat2ywl(x)		// Character
			case 15 then s=list2ywl(x, lv+1)	// Recursive call
			case 16 then s=list2ywl(x, lv+1) 	// tlist: treated as list
			else 
				error('Error in list2ywl: Type of element not supported.')
		end
		if i~=n then						// Last element?
			str = str + s + c
		else
			str = str + s
		end
	end
			
endfunction
