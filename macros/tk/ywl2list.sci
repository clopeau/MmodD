function e=ywl2list(str, lv)
//		Concatenate a string following MY :) convention back to a list.
//		Used for parameter passing between Scilab and Tk/Tcl.
	if ~exists('lv','local') then lv=0; end		// Start at root by default
	// String separater						
	c = '@'+string(lv)+'@'	
	k=strindex(str,c)
	if k<>[] then
	  estr = strsplit(str,[k-1;k+2])
	  estr = estr(1:2:$)
	else
	  estr=str
	end
	
	n = size(estr,'*')
	if n == 1 then							// Not a list
		e = ywl2mat(str)					// Return it as a matrix		
	elseif estr(2)==""	then					// Special case for list()
		e = list()
		return
	else
		select estr(1)
			case 'list' then
				e = list()				// list
				for i=[2:n]
					e(i-1) = ywl2list(estr(i),lv+1)	// Recursive call
				end
			case 'tlis' then				// typed list
				e = tlist(ywl2mat(estr(2)) )
				for i=[3:n]
					e(i-1) = ywl2list(estr(i),lv+1)
				end
		end		
	end

endfunction
