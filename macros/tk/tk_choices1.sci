function [result] = tk_choices1(title,items,align)
//		Substitution of x_choices
//		Call tk_choices to carry out the actual function
	[lhs,rhs] = argn(0)
	if rhs<3 then align=%t,end
	labels = []
	defaults = []
	choices = list()
	for i=1:size(items)
		labels(i) = items(i)(1)
		defaults(i) = items(i)(2)
		choices(i) = items(i)(3)
	end
	result = tk_choices(title,labels,choices,defaults,align)
	
endfunction
