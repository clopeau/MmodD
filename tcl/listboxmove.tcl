proc listboxmove {lb idx des} {
##		Move an element in a listbox up/down or to a new position
##		des specify the steps moved or the new position

	set idx [$lb index $idx]
	if {[lsearch {+ -} [string index $des 0]] >= 0} then {
		set des [expr $idx + $des]
		if {$des < 0} then {
			set des 0
		}
		if {$des >= [$lb size]} then {
			set des [expr [$lb size] - 1]
		}
	}	
	set str [$lb get $idx]
	$lb delete $idx
	$lb insert $des "$str"
	$lb activate $des
	$lb selection clear $idx
	$lb selection set $des
	return ""
}
