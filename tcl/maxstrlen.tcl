proc maxstrlen {lst {max 0}} {
##		Find out the length of the longest string in a list
	foreach i $lst {
		set l [string length $i]
		set max [expr $l > $max ? $l : $max]
	}
	return $max
}
