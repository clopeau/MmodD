proc sci_btn {} {
##		Return the color of button
	global sci_ButtonColor
	if {[info global sci_ButtonColor] == ""} then {
		set sci_ButtonColor #87ceeb
	}
	return $sci_ButtonColor
}
