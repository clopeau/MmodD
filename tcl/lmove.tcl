proc lmove {l idx des} {
##		Move an element up/down a list or to a new postion of the list
##		des specify the steps moved or the new position

	if {[lsearch {+ -} [string index $des 0]] >= 0} then {
		set des [expr $idx + $des]
	}
	set c [lindex $l $idx]
	set l1 [lreplace $l $idx $idx]
	set l1 [linsert $l1 $des $c]
	return $l1
}
