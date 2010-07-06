proc sci_ebk {} {
##		Return the background color of entry field
	global sci_EntryColor
	if {[info global sci_EntryColor] == ""} then {
		set sci_EntryColor #ffffff
	}
	return $sci_EntryColor
}
